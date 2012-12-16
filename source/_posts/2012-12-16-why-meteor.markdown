---
layout: post
title: "为什么是Meteor - 它和我们熟悉的框架有何不同？"
date: 2012-12-16 14:29
comments: true
categories: [meteor]
---

# Meteor是什么？

Meteor的官网( http://meteor.com )这样介绍这个框架：

> Meteor is an open-source platform for building top-quality web apps in a fraction of the time, whether you're an expert developer or just getting started.

**top-quality web apps** 我们放下不表，**fraction of the time** 的提法很新颖，看来这个框架的目标是解放程序猿，少花时间多办事。虽然具体的演化路径我不得而知，但从网络上的各种蛛丝马迹来看，Meteor吸收了google wave, asana等平台背后的开发工具的精髓，逐渐演进出了目前的版本。Meteor的幕后团队相当强悍：他们大多毕业于MIT，是成功的创业家，也是一流的工程师，其中一个开发者还是神器 [etherpad]( http://etherpad.net) 的作者。

<!-- more -->

## Meteor究竟有什么NB的地方？

首先，Meteor构架与nodejs之上。这使得 **One Language** 成为可能，同时可依托nodejs上诸如soket.io这样强大的类库内置 **realtime**，**Date on the Wire** 等特性。

在一种语言的基础上，Meteor统一了服务器端和客户端的数据访问，提出 **Database Everywhere**，一套DB API大大减轻了开发负担，不用再做server data JSON client data的转换（想想你的django 或者rails app，在这上面花了多少功夫？）。

为了让app达到最佳的用户体验，Meteor还提供了 **Latency Compensation**，客户端对数据的更新即时反应到UI，如果更新被服务器reject，再rollback。大多数情况下，用户会得到极佳的类似本地数据库的体验。

Meteor最让人叫绝的是其 **Full Stack Reactivity**。关于reactivity programming的详细介绍，请参考 [Reactivity Programming](http://en.wikipedia.org/wiki/Reactive_programming)，这里不展开。简言之，当数据发生改变的时候，所有依赖该数据的地方自动发生相应的改变。

用过backbone的同学都知道，当model发生改变的时候，我们需要通过注册相应的事件，显式更新对应的DOM，如果数据在页面中多处被渲染，则每处对应的DOM需挨个更新。

ember在backbone的思想上更近了一大步，通过内置的data binding API，让数据和DOM能够双向绑定，程序猿不用再花心思去考虑DOM的更新。然而，蹩脚的API调用（所有对binding的数据的访问需要通过getter和setter，你懂的）和DOM中无处不在的script垃圾让ember既不简约也不优雅。

而Meteor则另辟蹊跷，通过reactivity context和dependency巧妙地支持了reactivity（据作者说核心代码就几十行），使用者几乎感受不到代码的变化。

Meteor另一个很贴心的点是零部署。开发web app有点小头疼的点是打包和部署。比如说，把less转成css，coffee转成javascript，然后混淆，压缩，虽然有些自动化的工具可以简化这部分工作，可还免不了相应的配置和一些脚本工作。在开发环境下，meteor会自动替你加载js/css，如果你是用了coffee/less (sass)，只要add了相应的smart package，meteor会自动帮你处理；开发完毕后要部署，只需要运行 ```meteor bundle```，系统自动会将相关的资源打包，只要目标系统上有相应版本的nodejs，meteor和mongodb，就能运行一个标准的production版本。

以下是meteor官网上的介绍，当你真正使用meteor后，会发现还真不是吹牛。

> ## Seven Principles of Meteor
>
> 1. Data on the Wire. Don't send HTML over the network. Send data and let the client decide how to render it.
>
> 1. One Language. Write both the client and the server parts of your interface in JavaScript.
>
> 1. Database Everywhere. Use the same transparent API to access your database from the client or the server.
>
> 1. Latency Compensation. On the client, use prefetching and model simulation to make it look like you have a zero-latency connection to the database.
>
> 1. Full Stack Reactivity. Make realtime the default. All layers, from database to template, should make an event-driven interface available.
>
> 1. Embrace the Ecosystem. Meteor is open source and integrates, rather than replaces, existing open source tools and frameworks.
Simplicity Equals Productivity. The best way to make something seem simple is to have it actually be simple. Accomplish this through clean, classically beautiful APIs.

# Meteor入门范例

废话说那么多，是骡子是马，不如拿出来溜溜。以下是meteor create --example leaderboard产生的代码，很好懂，借花献佛。先看DOM结构，meteor目前仅支持 [handlebar](http://http://handlebarsjs.com/) 做为template engine。

{% include_code leaderboard.html %}

可以看到html被简化了不少，不用显式应用js/css。这段代码很好懂。再看看javascript，也是leaderboard的核心功能。javascript文件主要实现了template的事件及数据的CRUD。

{% include_code leaderboard.js %}

不到50行代码，提供了从model创建与fixture setup，到渲染模版和事件处理。想想用现有的任何一个框架，实现同样的功能，需要多少代码？

要运行以上范例，安装好meteor后，仅需：

```
$ meteor create --example leaderboard
$ cd leaderboard
$ meteor
```

然后打开浏览器，访问：http://localhost:3000。

# 敬请期待

从meteor 0.3.8版本开始学习和使用，到目前的0.5.2，我对meteor虽不敢说已经通盘掌握，也能够做一些稍微复杂的项目。接下来我会撰写一系列的文章，从本文提到的例子leaderboard的增强版开始，由浅入深，探讨如何通过学习meteor的架构和API，使用meteor做一些有意思的项目。

大纲如下：

* Meteor入门指南 - 如何安装，基本元素和包管理 -- 2012.12.23前
* 第一个Meteor App: 正字系统（leaderboard变种） -- 2012.12.30前
* Meteor的权限和用户账号系统 -- 2013.01.06前
* 将Meteor部署到自己的服务器 -- 2013.01.13前

# Reference

1. [http://meteor.com](http://meteor.com)
1. [Meteor文档](http://docs.meteor.com)
1. [Meteor Roadmap](https://trello.com/board/meteor-roadmap/508721606e02bb9d570016ae)
