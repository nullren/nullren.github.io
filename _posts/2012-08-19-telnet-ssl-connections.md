---
layout: post
title: "telnet ssl connections"
category: 
tags: [rawr,forgetful, win]
---
i always forget this at some point or another, but to get a regular
telnet-like session with ssl enabled servers, just do this:

    $ openssl s_client -quiet -connect $server:$port

boom yada.
