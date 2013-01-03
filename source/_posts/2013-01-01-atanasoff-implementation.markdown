---
layout: post
title: "Atanasoff实现摘要"
date: 2013-01-01 21:46
comments: true
categories: [technology]
tags: [atanasoff]
published: false
---

## 搭建环境

### Scaffold
虽然express可以直接生成项目的scafford代码，但我需要一套支持jade，less和coffeescript的bolerplate tool。在github上找到一个 [skeleton](https://github.com/EtienneLem/skeleton)，恰好满足我的需要。

```
$ skeleton --renderer jade --css less --js coffee atanasoff
```

<!--more-->

修改下package.json，添加mocha和should的支持。

``` json
{
    "name": "atanasoff"
  , "description": "easy blogging with octopress for non-hackers."
  , "version": "0.0.1"
  , "dependencies": {
        "express": ">3.0"
      , "connect-assets": "2.x"
      , "jade": "*"
      , "less": "*"
      , "coffee-script": "*"
    }
  , "scripts": {
      "start": "server.js"
    }
  , "engines": {
        "node": "0.8.16"
      , "npm": "1.1.x"
    }
  , "devDependencies": {
      "mocha": "*"
    , "should": "*"
    }
}
```

然后在项目目录下安装依赖。

```
$ npm install
```

### 搭建Mocha环境

```
$ npm install -g mocha
```

运行 ```node```，看看项目是否能正常运行：

```
$ node server.js
Express server listening on port 3000 in development mode
```

创建一个测试文件 ```test/test.coffee```，看看mocha能否正常运行：

``` coffeescript
require "should"

describe "feature", ->
  it "should add two numbers", ->
    (2+2).should.equal 4
```

然后运行：

```
$ mocha --compilers coffee:coffee-script

  ․

  1 test complete (1 ms)
```

注意mocha最新的版本已经不默认处理coffeescript了，所以直接运行 ```mocha``` 不会运行任何test。

如果想mocha一直监控test目录的变化：

```
mocha -w -G --compilers coffee:coffee-script
```

### 客户端包管理 - [bower](http://twitter.github.com/bower/)

安装bower：

```
$ npm install -g bower
```

安装 ```jquery```，```bootstrap```，```underscore``` 和 ```ace```：

```
$ bower install jquery
$ bower install bootstrap
$ bower install underscore
$ bower install ace
```

### i18n

找到了一个node的i18n package：[i18-node](https://github.com/mashpie/i18n-node)。

先把 ```"i18n": "*"``` 添加到 ```package.json```，然后运行 ```npm install``` 安装。




{% comment %}
开启一个新的项目时，代码结构非常重要。不合理的结构会让一个项目在代码规模逐渐趋于庞大的时候变得举步维艰，难以修改，之前做过的几个django项目我就走过不少弯路。可惜，现在但凡tutorial，都尽量保持简单，
{% endcomment %}