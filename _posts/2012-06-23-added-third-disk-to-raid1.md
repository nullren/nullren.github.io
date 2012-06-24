---
layout: post
title: "added third disk to raid1"
category: 
tags: [linux, mdadm, raid, raid1, win, rawr, derp]
---
this was very similar to the last post, but instead of just
[adding another disk](/2012/06/20/hot-swapping-harddrives), i had to
also *grow* the array so that the new disk would sync up instead of
remain a spare. that was accomplished with the following command:

    $ sudo mdadm --grow --raid-disk=3 /dev/md0

now everything is syncing up and i should have a little better read
speeds. yay!
