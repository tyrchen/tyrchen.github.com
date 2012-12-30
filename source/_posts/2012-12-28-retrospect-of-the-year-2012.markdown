---
layout: post
title: "Retrospect of the year 2012"
date: 2012-12-28 14:56
comments: true
categories: [retro]
tags: [english, retro]
---

The year 2012 was an unusal year. As a sophomore in the self-employed battlefield, I experienced a lot this year, and learned my lessons. 

If you ask what the biggest lesson I've learned, I would say - the only thing unchanged is the change itself, you need to prepare for it and adapt to it. For the year 2012, the obvious changes for the team were:

* We lose a key team member and it hurt me a lot.
* We acquired fresh blood and that was a great shot.
* We had to cut down the size of the team to move faster. Believe me, I felt much more paintful than anyone else. For the whole month I was in anguish until everyone paved to their new journey.
* We built a series of city guide apps, which got passionate responses from our users. One of the apps, Hong Kong Travel Guide, held a position of No. 1 in travel leaderboard of Hong Kong app market for a period, which was a wonderful thing considering that we spent __$0__ to market it.
* We successfully built our next gen software and would launch it formally early next year.

<!-- more -->

There were several great changes on me:

* I finished one of the greatest upgrade in my life - my lovely baby, lingxi, born at the end of this year.
* I read tens of books but most of them were not in CS field. This year I began to be obsessed by philosophy and literature of the pre-Qin period, so I read quite a few on that.
* I started using Meteor, a great nodejs framework for next gen web applications. By using Meteor, I spent about 5 nights on creating a collaboration tool for my team. Now this tool, called teamspark, is the defacto collaboration software of the team.
* I started blogging again. This time, by using octopress and sublime, I was totally immersed in the joyous composing state.
* I changed my little red elf Palio to a medium-sized car. For my baby, of course.

Just like what I've done for the past years, this retrospection will be divided into several parts, including work, study, life and finance. I'll try to make it more personal.

## Work

> Our work is the presentation of our capabilities.

### Projects I participated in


Projects | Commits | Diffs(LOC)| Intro
--------:|--------:|--------:|:-------------------
Cayman   | 591     | 232798 | next gen tukeq code
Atlantis | 1463    | 1654858| tukeq code
Teamspark | 135    |  37190 | collaboration tool
Zhengzi  | 9       | 2408   | little app for fun
Cuba     | 58      | 157502 | an obsoleted platform

Note: 

[1] to get git diff you made:

```
$ git log --author="YOUR NAME" --pretty=tformat: --numstat | gawk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }'
```

this requires gawk. Use ```apt-get``` (ubuntu) or ```brew``` (osx) to install it in case you didn't have it.

[2] to get commits you made:

```
$ git shortlog --numbered --summary
```

### Books I read (related with my job)

* 黑客与画家
* 松本行弘的程序世界
* 创新者的窘境
* 管理的实践
* Founders at Work (not finished)
* More Joel on Software (not finished)
* 乌合之众 (not finished)
* RFC 2616 (HTTP 1.1)
* ...

### Habits I acquired or maintained

* Get up at 5:30a.m. Monday to Friday; 7:00a.m. Saturday to Sunday.
* Read [36kr](http://36kr.com) and [hacker news](http://news.ycombinator.com) every morning for about an hour (mostly from 7:00-8:00a.m.)
* Sweep github repos by languages ([python](https://github.com/languages/Python) and [javascript](https://github.com/languages/JavaScript) most of the time) to find interesting repos around 12:30-13:00p.m. every day.
* Try to have a sleep at noon.
* Record the product inspirations and find interesting and realizable ones to carry out (that's why teamspark came out).
* Read at least one book per month.

### Other numbers I got

* 200+ starred github repos
* 50+ one one talks with team members
* 26 created github repos for business purpose and personal use
* 24 forked github repos
* 10+ phone & face-to-face interviews
* 5 stackoverflow anwsers (3 were up voted, 1 was down voted)
* 4 frameworks studied and tried out: bootstrap, meteor, express, ember
* 3 new language mastered: CoffeeScript, Less and Markdown
* 2 templating systems learned and used: Handlebars and Jade
* 2 blogs created ([one](http://tchen.me) for me, [the other](http://lingxi.tchen.me) for my lovely baby).
* 1 installation scripts just like what meteor did for their framework installation.
* 0 pull requests

## Study

### frontend tech

For frontend bolerplate, I studied [twitter bootstrap](http://twitter.github.com/bootstrap/), and kept an eye open on [HTML5 bolerplate](http://html5boilerplate.com/).

For javascript,

* The biggest surprise is [Meteor](http://meteor.com).
* I became a fan of [underscore](http://underscorejs.org/) but looking forward to [lodash](http://lodash.com/).
* I liked the simplicity of [backbone](http://backbonejs.org) but finally I chose [ember](http://emberjs.com) for my projects.
* After seeking for many local storage packages, I locked down to [amplify](http://amplifyjs.com/).
* I learned [reveal.js](http://lab.hakim.se/reveal-js/) and [embedded it](http://tchen.me/blog/2012/12/26/reveal-js-support-for-octopress/) into octopress for easy slide composition.
* I played with [d3](http://d3js.org/) and [nvd3](http://nvd3.org/) in the project teamspark for displaying statistics charts.

### Backend tech

* The biggest surprise is Meteor, too.
* I began to fight in the nodejs battlefield.
* I reread [RFC2616](http://www.ietf.org/rfc/rfc2616.txt) for grouping my knowledge fragments about HTTP.
* I mastered the technique of seamlessly deploying.
* Though we switched our major server for [tukeq.com](http://tukeq.com) from AWS to local IDC (you know the reason) and removed almost all services outside mainland China (such as cloudflare) for about a year, I still payed close attenttion to technologies used by AWS, Cloudflare, Mixpanel, Optimizely, etc.
* I switched DB server from mongodb back to mysql for company's projects but mongodb is still my favorite for personal projects.
* "Generate to static" technology like [Jekyll](https://github.com/mojombo/jekyll) caught my attention, and I did spend quite a few time on it.
* I picked up my C / assembly / Makefile experience again, and use makefile in my projects for a kind of automation.
* I started to read several hot open source code like redis which in pure C.

### Books I read for my personal interest

* History: I read several books regarding history. For the first time in my life, I finished reading __史记__.
* Literature: I reread __三国演义__ and __水浒__ (including __金圣叹批读水浒传__).
* Philosophy: I read __老子__, __论语__, __荀子__, __庄子__. I like __庄子__ the most.
* Biography: I read __李鸿章传__ and __王安石传__ (not finished) by _梁启超_. __李鸿章传__ might be the best biography I've read so far. It did a lot of interesting comparisons among Li and other politician, like Bismarck in Germany.
* Science: I read quite a few psychology books like __职业心理学__ (translated by _邹韬奋_) and several books about common sense, like __The Story of Mankind__ by _Hendrik Willem van Loon_.
* Others: I read __三字经__, __Aespo's Fables__, __Grimm's Fairy Tales__, and __Andersen's Fairy Tales__, both for me and for my lovely baby. The __Aespo's Fables__ taught me a lot.

## Life

### Lingxi was born
My wife got pregnant early in this year. That was an unexpected pleasure. After a ten-month growing, bringing us many, many joys and pains, this little creature jumped out to this world finally. Since then she became the center of the family. 

I would spend as much as time on her education. I knew I could bring her a plentiful life but what I concerned the most was the richness of her spirit.

### Boring but peaceful prenatal life

I watched 0 movie, 0 play and 0 game this year. I did several excursions to 北戴河, 十渡, 红螺寺, 大觉寺 but made 0 long journey.

### THE first five-year WEDDING anniversary

My wif got pregnant on the same day of our five-year anniversary. Thanks to god's mercy!

## Finance

As self-employed, I took 0 or low salary for the past 2 years for the good of the company. Fortunately, the family's incoming could cover the expenses. We lead a much tighter life than 2 years ago but we were much happier than before. _孔子_ once said

> 君子谋道不谋食，忧道不忧贫。
> 
> 士志于道，而耻恶衣恶食者，未足与议也。

## Epilogue

You may ask why I wrote this in English, is it a kind of show-off? No. There are two reasons:

1. This blog is written for myself. It's not intended to get other's comments.
1. Just before I started to write, I got an inspiration - I've not used English for quite a long time, why not write it in English to see what's the current status? 

As usual, here's lingxi's latest photo:

{% img /images/photos/baby20121227.jpg %}
{% img /images/photos/baby20121228.jpg %}
