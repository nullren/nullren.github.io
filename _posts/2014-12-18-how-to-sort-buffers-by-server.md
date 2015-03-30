---
layout: post
title: "how to sort buffers by server in weechat"
category:
tags: []
---

i sometimes get too many buffers open and open accross many different
networks. xchat and hexchat nicely sort channels under the server they
are connected to, but weechat is a little different since it is not a
gui.

this is border line magic. 

    /script install autosort.py
    /set irc.look.server_buffer independent
    /set buffers.look.indenting on

the only problem is that now buffers do not maintain the same number.
but this is something i can live with... for now.
