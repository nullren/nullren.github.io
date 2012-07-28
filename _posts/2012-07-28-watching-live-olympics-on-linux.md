---
layout: post
title: "watching live olympics on linux"
category: 
tags: [win, rawr, linux]
---

#### Using NBC ####
I was originally excited because NBC was going to use YouTube for live
streaming because YouTube works fairly well under linux. When I logged
into my Comcast account, NBC just continued to ask me to log in.
Apparently many other Linux users faced a similar problem. I eventually
figured out that Linux Mint 13 XFCE works completely fine and has no
problems. So I had to look for alternatives.

I spent a couple hours trying to figure out why nbcolympics.com worked
fine under Mint 13 and got nowhere. I installed the mint-flashplugin-11
package on my Arch desktop -- nothing.

#### Using BBC ####
Then I came across [this reddit
post](http://www.reddit.com/r/olympics/comments/xaj75/wanna_watch_the_bbc_live_stream/)
which then led me to this [tunlr forum
post](http://tunlr.net/forums/topic/getting-started-for-linuxunixbsd/).
This required me to change my `resolv.conf` to have these:

    nameserver 64.250.122.104
    nameserver 199.167.30.144

Then on that same page, it was suggested to set `resolv.conf` to be
*immutable*, ie:

    sudo chattr +i /etc/resolv.conf

Just need to remember to set it to `-i` when done. Now I am able to go
to [the BBC
website](http://www.bbc.co.uk/sport/olympics/2012/live-video) and view
the streams. 

##### BBC on my TV #####

To view a video in MPlayer is kind of a big deal for me since then I can
easily put the video on my television. I was lucky enough to come across
[this mailing list post for `get_iplayer`](http://www.mail-archive.com/get_iplayer@lists.infradead.org/msg03103.html)
and found this does exactly what I want.

To watch it in MPlayer, I just run the following command:

    get_iplayer --pid p00w2t4c --stdout --nowrite | mplayer -cache 512 -

The `pid` comes from the last part of the url when you go to any of the
streams on 

This means I can watch the Olympics live on my television.

I would still like to figure out how to get the NBC 720p streams on my
TV.
