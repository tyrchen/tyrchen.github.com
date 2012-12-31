---
layout: post
title: "进一步思考Atanasoff (Octopress client) (2)"
subtitle: "交互，设计，数据结构和技术方案"
date: 2012-12-31 09:53
comments: true
categories: [technology]
tags: [atanasoff]
---

[之前的文章](http://tchen.me/blog/2012/12/19/atanasoff-product-flow-chart/)把atanasoff的主要流程思考了一下，元旦期间考虑下atanasoff的实现。

## 交互

### 整站结构

{% img /images/charts/atanasoff-pages.jpg %}

<!--more-->
### 主要页面元素

{% img /images/charts/atanasoff-widgets.jpg %}

## 设计

### 数据结构

#### User

Field       | Description
:-----------|:--------------------------------
username    | 从github继承过来的username，不能修改
screen_name | 从github继承过来，暂时不能修改
avatar      | 从github继承过来，暂时不能修改
total_blogs | 博客总数

#### Blog

Field         | Description
:-------------|:--------------------------------
title         | blog的title，与config中的title冗余
repo_name     | github repo的名字
author        | blog的作者
location      | property. 该blog在磁盘中的路径
config        | json-style配置文件，_config.yml的内部表现形式
locked        | 是否处于编辑状态
total_posts   | 文章总数
total_pages   | 页面总数
total_slides  | 演示文档总数

#### Post

Field       | Description
:-----------|:--------------------------------
title       | post的title
location    | property. 该post在磁盘中的路径


### API (以 ```/api/v1/``` 开始)

#### Blog

Url                 | parameters             | Functionality
:-------------------|:-----------------------|:----------------
/blogs/new/         | P: repo_path, title    | 创建新的blog
/uname/blogs/       | G: page                | 列出uname下的博客
/uname/bname/       | G: type[post,page,slide] | 列出bname下的文章
/uname/bname/config | G <br> PUT: config     | 获取或设置bname配置

#### Post

Url                 | parameters             | Functionality
:-------------------|:-----------------------|:----------------
/uname/bname/pname/ | G <br> PUT: content    | 获取或设置文章正文


#### Activity

Url                 | parameters             | Functionality
:-------------------|:-----------------------|:----------------
/uname/activities/  | G: page                | 列出uname下的活动

#### Web hooks

Url                 | parameters             | Functionality
:-------------------|:-----------------------|:----------------
/uname/bname/hook   | : payload              | generate博客

需要学习下 [Post-Receive Hooks](https://help.github.com/articles/post-receive-hooks)。

## 技术方案 (nodejs)

### Technical Stack

* nginx做为web server
* express做为application server
* mongodb做为database server
* 使用 [mocha](https://github.com/visionmedia/mocha) 做BDD
* 使用 [jasny](http://jasny.github.com/bootstrap/index.html) 来bootstrap项目
* 使用 [jade](http://jade-lang.com/) 撰写模版
* 使用 [coffeescript](http://coffeescript.org) 写代码，[less](http://lesscss.org) 写样式

### 依赖的库

* github API和第三方登录：[node-github](https://github.com/ajaxorg/node-github)
* git lib用户提交代码和读取commit log：[node-gitteh](https://github.com/libgit2/node-gitteh)。libgit2的nodejs binding。貌似现在不支持写入。

## 后记

元旦开工，但基本只有清晨和晚上有时间。争取3天下来做个能用的雏形。

依旧例，上小宝照片一张。

{% img /images/photos/baby20121231.jpg %}
