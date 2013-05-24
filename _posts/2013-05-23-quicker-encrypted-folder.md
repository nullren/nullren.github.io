---
layout: post
title: "quicker encrypted folder"
category: 
tags: []
---

### encfs

    $ encfs ~/private ~/unlocked

this sets up the folders if they do not exist and it mounts them if
they do.

    $ fusermount -u ~/unlocked

this umounts it. quicker and easier.
