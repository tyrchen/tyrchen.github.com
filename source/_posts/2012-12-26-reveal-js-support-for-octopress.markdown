---
layout: post
title: "Octopress支持reveal.js撰写slides"
date: 2012-12-26 21:10
comments: true
categories: [tools, octopress]
tags: [octopress]

---

[reveal.js](https://github.com/hakimel/reveal.js)是一个NB的HTML presention framework，可以使用一些简单地HTML标签撰写出效果很赞的演示稿，并通过互联网传播。具体效果可以看[这里](http://lab.hakim.se/reveal-js/)。本文不是介绍如何使用或者撰写使用reveal.js的演示稿，这些可以通过reveal.js的文档很快速地掌握。作者比较好奇的是，既然octopress能够生成静态Html，那么如何很方便地将reveal.js集成到octopress中，让blog和presentation能够更好地结合起来？？

简单看了下octopress的代码，似乎不是太难，只要创造一个新的用于slide的layout，然后提供一条用于撰写slide的rake命令就可以。那还犹豫什么？挽起袖子，开干！

补记：下面的内容适合那些想深入了解octopress plugin做法的人，如果你非代码控，可以在你的octopress根目录下使用如下代码一键安装（仅在osx下测试过，应该对2.x版本均有效，有问题微博@或私信我）：

```
$ curl http://sh.tchen.me/install/octopress_reveal.sh | sh
```

如果见到这样的文字：

> reveal.js for octopress has been installed! To get started fast:
>
>  $ rake new_slide["Your slide name"]
>
>  $ vim source/slides/your-slide-name/index.markdown
>
> ...

就说明安装成功了。

<!--more -->

## Slide layout

在 ```source/_layouts``` 下，创建一个新的slides.html做为presentation页面的layout（代码有点长）:

{% codeblock slides.html %}
<!doctype html>
<html lang="en">

  <head>
    <meta charset="utf-8">
    <title>{% if page.title %}{{ page.title }} - {% endif %}{{ site.title }}</title>
    <meta name="author" content="{{ site.author }}">

    {% capture description %}{% if page.description %}{{ page.description }}{% else %}{{ content | raw_content }}{% endif %}{% endcapture %}
    <meta name="description" content="{{ description | strip_html | condense_spaces | truncate:150 }}">
    {% if page.keywords %}<meta name="keywords" content="{{ page.keywords }}">{% endif %}

    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />

    <link rel="stylesheet" href="{{ root_url }}/stylesheets/reveal/reveal.min.css">
    <link rel="stylesheet" href="{{ root_url }}/stylesheets/reveal/theme/{{page.theme}}.css" id="theme">

    <!-- For syntax highlighting -->
    <link rel="stylesheet" href="{{ root_url }}/stylesheets/reveal/zenburn.css">

    <!-- If the query includes 'print-pdf', use the PDF print sheet -->
    <script>
      document.write( '<link rel="stylesheet" href="{{ root_url }}/stylesheets/reveal/print/' + ( window.location.search.match( /print-pdf/gi ) ? 'pdf' : 'paper' ) + '.css" type="text/css" media="print">' );
    </script>

    <!--[if lt IE 9]>
    <script src="{{ root_url }}/javascripts/html5shiv.js"></script>
    <![endif]-->
  </head>

  <body>

    <div class="reveal">

      <!-- Any section element inside of this container is displayed as a slide -->
      <div class="slides">
        {{ content }}
      </div>

    </div>

    <script src="{{ root_url }}/javascripts/reveal/head.min.js"></script>
    <script src="{{ root_url }}/javascripts/reveal/reveal.min.js"></script>

    <script>

      // Full list of configuration options available here:
      // https://github.com/hakimel/reveal.js#configuration
      Reveal.initialize({
        controls: true,
        progress: true,
        history: true,
        center: true,

        theme: Reveal.getQueryHash().theme, // available themes are in /css/theme
        transition: Reveal.getQueryHash().transition || 'default', // default/cube/page/concave/zoom/linear/none

        // Optional libraries used to extend on reveal.js
        dependencies: [
          { src: '{{ root_url }}/javascripts/reveal/plugin/classList.js', condition: function() { return !document.body.classList; } },
          { src: '{{ root_url }}/javascripts/reveal/plugin/markdown/showdown.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
          { src: '{{ root_url }}/javascripts/reveal/plugin/markdown/markdown.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
          { src: '{{ root_url }}/javascripts/reveal/plugin/highlight/highlight.js', async: true, callback: function() { hljs.initHighlightingOnLoad(); } },
          { src: '{{ root_url }}/javascripts/reveal/plugin/zoom-js/zoom.js', async: true, condition: function() { return !!document.body.classList; } },
          { src: '{{ root_url }}/javascripts/reveal/plugin/notes/notes.js', async: true, condition: function() { return !!document.body.classList; } }
          // { src: '{{ root_url }}/javascripts/reveal/plugin/remotes/remotes.js', async: true, condition: function() { return !!document.body.classList; } }
        ]
      });

    </script>

  </body>
</html>

{% endcodeblock %}

具体代码我就不解释了，大部分内容源自reveal.js repo的index.html，我只是对于octopress做了必要的修改。注意，要使layout中的css/js生效，请将reveal.js下的相应文件拷到octopress对应的目录下。

有了这个模版，撰写presentation的用户就不必关心slide页面的具体设置，甚至不需要知道有reveal.js这回事。

## rake new_slide

接下来就是自动化生成新的slide文件。我们希望能够像撰写blog或者page那样，```rake new_post``` 或 ```rake new_page``` 就可以生成新的slide。

对比着new_page，依葫芦画瓢，在Rakefile里添加代码如下：

{% codeblock Rakefile.rb %}
# usage rake new_slide[my-new-slide] or rake new_slide[my-new-slide.html] or rake new_slide (defaults to "new-slide.markdown")
desc "Create a new slide in #{source_dir}/#{slide_dir}/(filename)/index.#{new_page_ext}"
task :new_slide, :filename do |t, args|
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  args.with_defaults(:filename => 'new-slide')
  page_dir = [source_dir, slide_dir] # [source_dir]
  if args.filename.downcase =~ /(^.+\/)?(.+)/
    filename, dot, extension = $2.rpartition('.').reject(&:empty?)         # Get filename and extension
    title = filename
    page_dir.concat($1.downcase.sub(/^\//, '').split('/')) unless $1.nil?  # Add path to page_dir Array
    if extension.nil?
      page_dir << filename
      filename = "index"
    end
    extension ||= new_page_ext
    page_dir = page_dir.map! { |d| d = d.to_url }.join('/')                # Sanitize path
    filename = filename.downcase.to_url

    mkdir_p page_dir
    file = "#{page_dir}/#{filename}.#{extension}"
    if File.exist?(file)
      abort("rake aborted!") if ask("#{file} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
    end
    puts "Creating new page: #{file}"
    open(file, 'w') do |page|
      page.puts "---"
      page.puts "layout: slides"
      page.puts "title: \"#{title}\""
      page.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
      page.puts "theme: beige"
      page.puts "---"
    end
  else
    puts "Syntax error: #{args.filename} contains unsupported characters"
  end
end
{% endcodeblock %}

运行这条命令，会在slides目录下自动生成指定的presentation的skeleton。接下来要做的就是在正文中填写一个个section了。注意：section里的代码可以是markdown，因为octopress在编译时会自动扫描markdown并编译成对应的html。

到这里，你的octopress blog已经支持presentation文档的撰写了，还不使用 ```rake new_slide["my first slide"]``` 尝试撰写一个？？

## 如果我想把presentation嵌入到我的博客中呢？

把presentation像下面这样嵌入到blog中其实是我的最大需求。它直接促成了这篇文章中所述的所有内容的产生。

{% reveal /slides/my-first-slide 640 480 %}

这个究竟该怎么做？其实很简单，写个plugin就能搞定。在 ```plugin``` 目录下创建 ```reveal_tag.rb```，填入以下代码：

{% codeblock reveal_tag.rb %}
# Title: Simple Reveal presentation tag for Jekyll
# Author: Tyr Chen http://tchen.me
# Description: output embedd tag for reveal js presentation
#
# Syntax { % reveal url/to/presentation [width height] % }
#
# Example:
# { % reveal http://site.com/presentation.html 640 480 % }
#
# Output:
# <embed src="http://site.com/presentation.html" allowFullScreen="true" width="640" height="480" align="middle"></embed>
#

module Jekyll

  class RevealTag < Liquid::Tag
    @url = nil
    @height = ''
    @width = ''

    def initialize(tag_name, markup, tokens)
      if markup =~ /((https?:\/\/|\/)(\S+))(\s+(\d+)\s(\d+))?/i
        @url  = $1
        @width  = $5
        @height = $6
      end
      super
    end

    def render(context)
      output = super
      if @url
        reveal = "<embed src='#{@url}' allowFullScreen='true' width='#{@width}' height='#{@height}' align='middle'></embed>"
      else
        "Error processing input, expected syntax: {% reveal url/to/presentation [width height] %}"
      end
    end
  end
end

Liquid::Template.register_tag('reveal', Jekyll::RevealTag)
{% endcodeblock %}

就可以在博文中使用 ```reveal``` 很方便地嵌入做好地presentation了。具体怎么写，看代码注释。

## 后记

有空的话我会将本文提到的内容制作成octopress的一个plugin，方便大家使用。

依旧例，放上小宝今日照片一张：

{% img /images/photos/baby20121226.jpg %}