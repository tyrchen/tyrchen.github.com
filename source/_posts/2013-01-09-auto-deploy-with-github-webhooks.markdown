---
layout: post
title: "用Github Webhooks实现自动部署"
date: 2013-01-09 22:10
comments: true
categories: [tools]
tags: [automation]
---

## 问题

互联网产品永远都处在不断更迭的beta阶段。我们常常会在生产环境外，建立一套与生产环境共享数据的lab环境，以便验证一些即将用于真实世界的想法。问题是，每次提交改动后都需要手工运行部署脚本（前后大概花去30s左右时间），很不高效，每天运行那么几次，对惜时如金的程序员来说是种磨难。于是忙中偷闲的时候，就会想：有没有一种方法在代码提交后能够自动部署，身躯手工的麻烦？

当然是有的。Github的 [Post receive hooks](https://help.github.com/articles/post-receive-hooks) 就是用来干这个滴。作者花了小半天时间（对nodejs不熟啊），实现了一个很简单的自动部署方案，趁着记忆还未散去，将其记录在案，和大家分享交流。

<!--more-->

## 需求

这个小工具的需求很简单，可以抽象为：对于指定的repositories上的指定branch，如果发生改动，执行一个action。

比如说：

* tukeq的master branch改动，执行lab_deploy的动作。
* tukeq的production branch改动，执行safety_check的动作。

这是最基本的需求，当然在其之上还有很多衍生需求，比如说时间比较长的action是否可以取消，同样的action能否聚合处理等等，在这里就不讨论。

需求简单，功能的实现方案也不难：

* 提供一个url给github用于接受Post receive处理流程发过来的数据
* 进行模式匹配，对于满足条件者，执行指定好的动作
* 指定的动作如果是个长任务，则需要使用MQ异步化

对于这样一个小东西，使用django貌似有点重了。正好最近学了点express的皮毛，就拿它来尝试。

## 准备工作

这个项目基本没有什么依赖，express/jade/underscore的标配外，加了个 [kue](https://github.com/LearnBoost/kue) 用于处理异步任务。

简单说下 ```kue```。它是个job queue，使用redis做job的存储。如果用过python下的celery，则对这类的工具应该不陌生。

celery实现一个异步任务（无与伦比的简洁与优雅）：

``` python
# caller
async_task.deplay(a, b)
# task
@task
def async_task(a, b):
  pass
```

kue做为后起之秀在语法上稍逊一筹：

``` javascript
# caller
jobs.create('async_task', data).priority('high').save();

# task
jobs.process('async_task', function(job, done) { ... });
```

如果你的redis跑在缺省端口，kue几乎就是零配置，这对于配置稍嫌复杂的celery来讲轻便不少。

## 开工

假定我们在Github上注册的webhook地址为：http://tukeq.com/deploy （一个虚拟的地址，不必当真），则我们的主要任务就是实现 ```deploy``` 路由。首先定义之：

``` javascript
var hook = require('./routes/githubhook')
app.post('/deploy', hook.githubhook);
```

接下来就是实现githubhook的逻辑了。我们先定义主逻辑：

``` javascript
exports.githubhook = function(req, res){
    var payload;
    // ensure paylaod is a object
    if (typeof req.body.payload === 'object') {
        payload = req.body.payload;
    } else {
        payload = JSON.parse(req.body.payload);
    }

    _.each(repos, function(repo) {
        if(repo.name === payload.repository.name && payload.ref.indexOf(repo.ref) >= 0) {
            repo.action(repo.name, repo.ref, payload);
        }
        res.send('ok');
    });
};
```

代码很简单，基本想法是使用一张模式表，里面包含了要匹配的项目，以及一旦匹配，使用何种action去处理。

下面看模式：

```
var repos = [
    {name: 'tukeq', ref: 'master', action: deploy},
    {name: 'tukeq', ref: 'live', action: log},
    {name: 'barr', ref: 'master', action: deploy}
];
```

没什么高深。如果改动是在tukeq这个repo的master branch上发生，则执行deploy action。

我们再看看deploy做什么：

``` javascript
var kue = require('kue')
    , jobs = kue.createQueue()
function deploy(repo, ref, data) {
    var name = 'github_' + repo + '_' + ref;
    var path = '/home/dev/bin/';
    var cmd = path + name;

    console.log('deploy:', repo, ref);

    jobs.create('deploy', {
        command: cmd
    }).save();
}
```

在服务端，我们有对应的deploy脚本，所以在这里，deploy的任务就是找到对应的脚本，启动一个kue job运行之。这里如果不使用异步任务，脚本很可能执行到一半就被杀掉。```nodejs``` 中http的缺省timeout是2分钟，所以即便我们在收到request后立即返回 __ok__ 做为response（见上文代码），超过两分钟后，脚本依然会收到 ```SIGTERM```（我在这里纠结了一阵子，本不想引入job queue，因为那样需要管理的任务又多了一个，但尝试了各种创建child process的方式后，还是没找到一个理想的方案）。

由于我们使用了job queue，必然需要一个job server来pull queue中的job并进行处理，于是我们单开一个脚本做任务处理：

``` javascript
var kue = require('kue')
    , jobs = kue.createQueue()
    ,exec = require('child_process').exec;

jobs.process('deploy', function(job, done){
    console.log('working on a deploy job', job.data.command);
    exec(job.data.command, function(err, output) {
        console.log('job done', err);
        done();
    });
});
```

OK，至此基本的代码逻辑就已经OK，我们可以分别把web server和job server运行起来，使用 [httpie](https://github.com/jkbr/httpie) 测试一下。

运行服务：

```
$ npm install # 确保所有依赖正确安装
$ node app
$ node jobs/process
```

如果你系统里没装 ```httpie```，强烈建议使用这个强大的，基于 [requests](http://docs.python-requests.org/en/latest/) 的python小工具。有了它，```curl``` 就好像是旧石器时代的简陋工具，你再也不想用哪怕一次。

安装：

```
$ sudo pip install httpie
```

使用：

```
$ http POST localhost:3000/deploy < test.json
```

这条命令所见即所得：把test.json做为body POST到localhost:3000/deploy。test.json是用于测试的数据：

``` json
{
  "before": "5aef35982fb2d34e9d9d4502f6ede1072793222d",
  "repository": {
    "url": "http://github.com/defunkt/github",
    "name": "github",
    "description": "You're lookin' at it.",
    "watchers": 5,
    "forks": 2,
    "private": 1,
    "owner": {
      "email": "chris@ozmm.org",
      "name": "defunkt"
    }
  },
  "commits": [
    {
      "id": "41a212ee83ca127e3c8cf465891ab7216a705f59",
      "url": "http://github.com/defunkt/github/commit/41a212ee83ca127e3c8cf465891ab7216a705f59",
      "author": {
        "email": "chris@ozmm.org",
        "name": "Chris Wanstrath"
      },
      "message": "okay i give in",
      "timestamp": "2008-02-15T14:57:17-08:00",
      "added": ["filepath.rb"]
    },
    {
      "id": "de8251ff97ee194a289832576287d6f8ad74e3d0",
      "url": "http://github.com/defunkt/github/commit/de8251ff97ee194a289832576287d6f8ad74e3d0",
      "author": {
        "email": "chris@ozmm.org",
        "name": "Chris Wanstrath"
      },
      "message": "update pricing a tad",
      "timestamp": "2008-02-15T14:36:34-08:00"
    }
  ],
  "after": "de8251ff97ee194a289832576287d6f8ad74e3d0",
  "ref": "refs/heads/master"
}
```

测试通过，大功告成。

本文所述代码可以在这里找到：[https://github.com/tyrchen/simplehooks.git](https://github.com/tyrchen/simplehooks.git)。欢迎clone/fork。

## 部署

光有代码还没用，要将其部署到一个github能够访问到的server上。我喜欢用supervisor进行部署：

Simple hook服务：

```
[program:simplehooks]
directory = /home/dev/deployment/simplehooks
user = dev
command=/usr/local/bin/node app
environment=PORT=12345
redirect_stderr=true
stderr_logfile=none
stdout_logfile=/var/log/supervisor/simplehooks.log
autostart=true
autorestart=true
```

Simple job服务：

```
[program:simplehookjobs]
directory = /home/dev/deployment/simplehooks
user = dev
command=/usr/local/bin/node jobs/process
redirect_stderr=true
stderr_logfile=none
stdout_logfile=/var/log/supervisor/simplehookjobs.log
autostart=true
autorestart=true
```

配置完后可以通过如下命令无缝运行：

```
$ supervisorctl
supervisor> reread
supervisor> update
```

当然不要忘记nginx配置：

```
server {
  listen 80;
  server_name sh.tukeq.com;
  set $simplehook_current_root "/home/dev/deployment/simplehooks";
  root @simplehooks;
  access_log /var/log/nginx/simplehooks.access.log;
  error_log /var/log/nginx/simplehooks.error.log;
  location / {
    proxy_pass http://localhost:12345;
    include /etc/nginx/proxy_params;
  }
}
```

## 后记

小宝笑了，依旧是那么天真无邪。看到她，我的苦闷阴霾一下子就没了。

{% img /images/photos/baby20130109.jpg %}