---
layout: post
title: "进一步思考Atanasoff (Octopress client) (1)"
subtitle: "产品流程图"
date: 2012-12-19 21:57
comments: true
categories: [technology]
tags: [atanasoff]
---

## 引子

Atanasoff基本的想法已经有了，接下来就是一些细节上的思考。晚上在家看小宝的同时，考虑了一下产品的主要流程。

<!-- more -->

## 注册流程

用户使用github接入后，Atanasoff需要为用户创建属于他的博客repo。

{% img /images/charts/atanasoff-registration.jpg %}

## 博客撰写和编辑流程

博客在编辑状态时，会被置为lock状态，这是为了避免用户在不同设备之间同一时间段内编辑同一篇博文导致冲突。以后支持operational transformation后，不需要此状态。

博客撰写时，为避免浏览器或app崩溃，需要定期将修改保存在local storage中；并在一定时间内提交到服务器。如果客户端10分钟内没有任何改动，则提交所有更改并退出编辑状态（让其它客户端有机会进行编辑）。

{% img /images/charts/atanasoff-blog.jpg %}


## 小宝照片

{% img /images/photos/baby20121219.jpg %}


