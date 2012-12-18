---
layout: post
title: "产品随想：octopress客户端"
subtitle: "解放程序猿的那双懒惰的手"
date: 2012-12-18 08:26
comments: true
categories: 
---

## 引子

我是个懒人，记性还差。写了两篇博客后，隔了一天，在写第三篇的时候，突然忘了新建博文的命令，是 ```rake new_post``` 还是 ```rake new_posts``` 来着？每次写完之余，多余的 ```rake gen_deploy``` 也总让我抓狂。不要会错意，我非常喜欢octopress这个产品，简洁的设计，独特的思想，优雅的撰写方式和美妙的历史记录，这些都让我沉浸在其中，乐不思WP，但如果再能好那么一点点，再让我少干些重复性的劳动，就完美了。

同事见了我的博客也想搭一个，我说这不适合你，octopress只适合程序猿。回过头来我想，为什么自己的视界这么狭小？程序猿是干什么的？不就是把复杂的工作交给计算机，让计算机前的人能够悠然自得么？

说不的程序猿不是好的产品经理。octopress已经为程序猿提供了一套 ```rake``` 的自动化工具。在这个基础之上，再提供一套和谐的工具给用户不就可以了么？是谁规定一定要搭建 ```ruby``` 环境才能搭建octopress博客？又是谁规定一定要会基本的 ```git``` 语法和 ```shell``` 命令才能使用octopress？

<!-- mroe -->

## Octopress客户端 —— Atanasoff

为了行文方便，我暂且将这个产品称之为 **Atanasoff** [1]。

### 用户注册和登录

Atanasoff的用户须以github第三方登录，且创建了username.github.com.git，并将其授权给Atanasoff的github账号atanasoffr（将其添加为collaborator）。

用户第一次注册后，服务端检查并帮用户设置为博客使用的repo，使用配置好的octopress。

### 设置

用户可以对自己的octopress博客进行简单的设置： 

* 博客基本信息
* 导航
* 插件如百度统计 / Google Analytics，duoshuo / disqus，微博秀等
* 个人域名

### 撰写

客户端提供 ```markdown``` 编辑器 [2]，让用户可以轻松编辑博客。服务器和客户端保持同步，客户端的修改或者新文章的撰写都会在有网络的情况下定期同步到服务器，再由服务器push到github。

为方便起见，markdown编辑器提供wysiwyg功能，让用户能够随时预览撰写的内容。编辑器尽可能美丽一些，sublime text 2带的MarkdownEditor插件就是一个很好的参考对象。

另外，提供图片上传和文件上传功能，上传的文件按类型放在repo相应的目录下，客户端同时生成对应的markdown语句，方便用户展示图片或提供下载链接。

### 部署

用户可以将写好的博文部署到github pages上进行访问。为性能计，部署的频率以5分钟为单位，不允许用户太频繁的部署。（因为 ```rake gen_deploy``` 是个相对较重的操作）。

### 支持多种客户端

Atanasoff能够支持多种客户端，并随时在这些客户端间保持同步。可以考虑先出一个对pad友好的支持响应式设计的web版本，然后进一步用phonegap提供xpad的支持。xphone的支持似乎意义不大，因为小屏幕似乎不太适合撰写。

考虑xpad主要是因为本文实际上是在搭地铁的一个多小时里用ipad上的evernote完成。

### 其他要素

支持中英文的界面

### 实现方案

python / django对我而言是最佳的选择，但我会考虑尝试nodejs。

### 背后的逻辑（随想，并不严谨）

* 服务端搭建合适的octopress生产环境，每个用户的repo都能正常运行 ```rake``` 命令。
* 当用户设置好后，clone他的repository，切换到source并检查是否有source/post，没有的话xfork [3] 出一个设置好的系统版本。
* 服务器使用socket.io推送post目录下的所有markdown文件（先考虑posts，以后考虑pages），及依据config生成的字典。
* ```rake``` 命令使用background task完成。
* 定期同步的文章内容可以记录在临时文件中并使用 diff / patch 的思想进行同步 [3]。由于这样的同步往往在自己的设备之间进行，不存在同时修改的情况，所以目前之版本无opertional transformation之必要。日后如有需要，可以添加 [etherpad](http://http://etherpad.org/) 的支持。


### 产品用途

* 个人博客
* 企业博客

## Reference

[1] 本博中假想的产品均冠以计算机科学家的名字，从A-Z依次排列。[Atanasoff](http://zh.wikipedia.org/wiki/%E7%BA%A6%E7%BF%B0%C2%B7%E6%96%87%E6%A3%AE%E7%89%B9%C2%B7%E9%98%BF%E5%A1%94%E7%BA%B3%E7%B4%A2%E5%A4%AB) 第一台自动电子数字计算机的发明者。

[2] JS的markdown wysiwyg编辑器有很多，比如说：[EpicEditor](http://oscargodson.github.com/EpicEditor/)。

[3] 随便google了下，似乎有 [JsonDiffPatch](https://github.com/benjamine/JsonDiffPatch) 可以尝试

[4] 协同工作软件的思想基石。 参见wikipedia下的介绍：[operational transformation](http://en.wikipedia.org/wiki/Operational_transformation) 

## 后记

今日小宝的照片随后送上。

