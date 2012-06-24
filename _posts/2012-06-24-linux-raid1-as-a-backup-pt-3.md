---
layout: post
title: "removing piece of linux raid1 to use as as a backup (linux raid
pt. 3)"
category: 
tags: [linux, md, raid1, raid, win, rawr, derp]
---

so, this was the final and ultimate step of what i'm proud to have
accomplished by tinkering around with this. with almost minimal effort
and heartbreak, i am able to pop in a hard disk, let it sync up to a
raid1 pool, and i can remove it and mount it and use it as a backup
source.

    sudo mdadm /dev/md0 -f /dev/sdc1
    sudo mdadm /dev/md0 -r /dev/sdc1
    sudo cryptsetup luksOpen /dev/sdc1 homebackup
    sudo mkdir /homebackup
    sudo mount -o ro /dev/mapper/homebackup /homebackup/
    ls /homebackup/
    ls /homebackup/ren/
    sudo umount /homebackup
    sudo cryptsetup luksClose homebackup

i will have to get into the habit of regularly syncing up a backup or
maybe i can start collecting harddisks. either way, this makes me feel
much more at ease with my desktop.
