---
layout: post
title: "watching live olympics on linux"
category: 
tags: [win, rawr, linux]
---

I was originally excited because NBC was going to use YouTube for live
streaming because YouTube works fairly well under linux. When I logged
into my Comcast account, NBC just continued to ask me to log in.
Apparently many other Linux users faced a similar problem. I eventually
figured out that Linux Mint 13 XFCE works completely fine and has no
problems. So I had to look for alternatives.

I spent a couple hours trying to figure out why nbcolympics.com worked
fine under Mint 13 and got nowhere. I installed the mint-flashplugin-11
package on my Arch desktop -- nothing.

Then I came across [this reddit
post](http://www.reddit.com/r/olympics/comments/xaj75/wanna_watch_the_bbc_live_stream/)
which then led me to this [tunlr forum
post](http://tunlr.net/forums/topic/getting-started-for-linuxunixbsd/).
Now I get the BBC streams live and I am happy--for now.

I would prefer to make the NBC site work since it had 720p and 1080p
streams.

**Update**

I installed latest git version of
[get_iplayer](http://www.mail-archive.com/get_iplayer@lists.infradead.org/msg03103.html)
since it was recently updated.

Then to watch it in mplayer, i just run the following command:

    get_iplayer --pid p00w2t4c --stdout --nowrite | mplayer -cache 512 -

The `pid` comes from the last part of the url when you go to any of the
streams on [the BBC
website](http://www.bbc.co.uk/sport/olympics/2012/live-video).

This means I can watch the Olympics live on my television.

I would still like to figure out how to get the NBC 720p streams on my
TV.
