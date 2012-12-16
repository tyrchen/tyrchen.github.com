---
layout: post
title: "第一篇博客"
date: 2012-12-16 04:15
comments: true
categories: [github pages, octopress, blog]
---
# 引子

夜夜哭闹的混世小魔王在她满月的这天好像突然换了个人，一觉又一觉地睡。这可苦了我，一个月来建立的夜间作息倾刻间紊乱，她没有闹觉的时间里，我却丢了魂一样，怎么也睡不着。于是起身想折腾点什么，无意间看到了derbyjs的 [blog](http://blog.derbyjs.com "Derby JS") 是github pages支持的，遂产生了兴趣，挽起袖子就开始折腾一个自己的。虽然 [octopress][1]的文档写得很清晰，但对于第一次接触这个博客系统的人来讲，还是有一些拦路虎的。2012年12月16日凌晨4:15，当我的第一篇空的博客展现在 [tyrchen.github.com](tyrchen.github.com) 时，我终于累瘫在床上。

早上9时，我翻身起来撰写此文，算是给自己折腾的那一个多小时时间一个交代吧。

免责声明：如果你不知道什么是shell, github, 不能很快地掌握一种非常简单的标记语言(markdown)，那么本文不适合你。类似于 [wordpress](http://wordpress.com) 所见即所得的博客系统对你更有价值。[octopress][1]适合于黑客。

# 什么是github pages? 

开源项目需要sell自己。项目的介绍，帮助和API文档都是很好的宣传工具。在没有github pages的日子里，项目只能自建站点或者使用第三方来存放能让用户立即阅读的文档。github看到了这一需求，将一个静态页面hosting的系统巧妙地与github本身结合起来，通过一个特殊的branch (gh-pages) 为项目提供文档hosting。除此之外，个人也有branding自己的需求，于是，只要你创建一个名为 yourname.github.com 的repository，github会自动为其提供同域名的hosting服务。

更多有关github pages的文档，见：[http://pages.github.com/](http://pages.github.com/)。

# 什么是octopress?

octopress提供了一组自动化的工具和模版帮助用户简化博客系统的创建。octopress生成的博客系统可以被方便地部署到github pages及heroku，当然，由于生成的是静态文件，你也可以将其部署到任何一个你自己的vhost或server。

octopress的安装文档见：[http://octopress.org/docs/setup/](http://octopress.org/docs/setup/)。本文接下来的部分会详细介绍如何用github pages和octopress部署一个自己的博客，及简单介绍如何进行写作。

<!-- more -->

# 安装

## 创建repository

在你的github账号下创建名为yourname.github.com的repository。注意，不要创建成yourname。创建好后留待后用。

## 安装ruby 1.9.3

如果你的系统中没有ruby或者 ```ruby --version``` 的版本不是1.9.3，请使用 [rvm](https://rvm.io/rvm/install/) 或者你熟悉的version manager安装1.9.3.

使用rvm安装ruby 1.9.3:

```
$ rvm install 1.9.3
$ rvm use 1.9.3
$ ruby --version
ruby 1.9.3p0 (2011-10-30 revision 33570) [x86_64-darwin12.2.0]
```

## 设置octopress

### 安装依赖

```
$ git clone git://github.com/imathis/octopress.git octopress
$ cd octopress    # 使用rvm时，系统会自动切换到1.9.3，第一次使用会提示是否trust .rvmrc，请输入yes
$ gem install bundler
$ bundle install
```

如果在这一步有任何问题，请查阅ruby手册或google报错信息。

### 安装缺省的模版

```
$ rake install
```

### 设置博客使用的repository

```
$ rake setup_github_pages
Enter the read/write url for your repository
(For example, 'git@github.com:your_username/your_username.github.com)
Repository url: 
```

请输入：```git@github.com:yourname/yourname.github.com.git``` (将yourname替换成你的github登录名)

这个步骤rake会做很多事情：
1. 在.git/config中替换origin为你输入的repository，并把原来的origin写到octopress中。
1. 创建新的branch source并切换到这个branch。
1. 在生成的_deploy目录下，初始化git repository为你的repository。

以下是两个git config的内容，just for your information。

```
tchen@tchen-mbp:~/projects/octopress$ cat .git/config 
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
	ignorecase = true
[remote "octopress"]
	url = git://github.com/imathis/octopress.git
	fetch = +refs/heads/*:refs/remotes/octopress/*
[branch "source"]
	remote = origin
	merge = refs/heads/master
	rebase = true
[remote "origin"]
	url = git@github.com:tyrchen/tyrchen.github.com.git
	fetch = +refs/heads/*:refs/remotes/origin/*
```

```
tchen@tchen-mbp:~/projects/octopress$ cat _deploy/.git/config 
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
	ignorecase = true
[remote "origin"]
	url = git@github.com:tyrchen/tyrchen.github.com.git
	fetch = +refs/heads/*:refs/remotes/origin/*

```

### 创建博文

接下来可以试试创建一个新的博文：

```
$ rake new_post["My first blog"]
```

这会在source/_posts下创建一个以时间和标题为名称的markdown文件，它就是你的第一篇博文。

使用：

```
$ rake preview
```

rake会启动一个server，打开浏览器访问 [http://localhost:4000](http://localhost:4000) 可以看到你的最新更改。

### 部署你的博客

```
$ rake gen_deploy
```

这个命令会把_deploy下的内容重新生成一遍，然后提交到你的repository。如果一切顺利，10分钟左右就可以通过 [http://yourname.github.com](http://yourname.github.com) 访问你的博客了。

### 保存你的更改

欢喜之余，不要忘记提交你的源文件。

```
$ git add .
$ git commit -m "Source code of my blog"
$ git push origin source
```

你的repository会多一个source目录，记载所有的源文件。

### 撰写博文

博客系统搭建好之后，如何撰写博文呢？通过之前的步骤想必你对octopress的精髓有所了解，yes，没有所见即所得的编辑器让你撰写博文，你要做的是使用 ```rake new_post``` 命令创建一篇新的文章，然后使用称手的markdown编辑器进行编辑即可。可选择的markdown编辑器很多，vim，sublime text 2，textmate 2等等。我个人喜欢在osx下使用sublime text 2。（需要安装Markdown Edit，不会安装？？请google ^_^）

基本的语法我就不多说了，浪费篇幅。看看这篇博文的源文件，你就掌握了markdown的大部分用法。（如果你第一反应是 鼠标右键->查看源文件，那么我被你打败了，我说的是markdown的源文件 ^_^）

还是不知道怎么看？好吧，[猛击这个链接]（https://raw.github.com/tyrchen/tyrchen.github.com/source/source/_posts/2012-12-16-first-blog.markdown）

# 后记

断断续续写了两个小时，期间还哄了下满月的小宝，拍下了一堆她满月的照片，选一张出来，算是对你耐心读完本文的奖励：

![小宝](http://tyrchen.github.com/images/photos/baby20121216.jpg)


[1]: http://octopress.org 'Octopress'