---
layout: post
title: "hot swapping harddrives (linux raid pt. 1)"
category: 
tags: [win, dumb, linux, raid, rawr]
---
one of the disks in my RAID1 died. it was one of the 2TB disks, so i
ordered a new one off newegg. it arrived today so i spent most of the
day waiting until the evening when i was done using the computer. when
it came time to swap out the disk, i thought i would be daring (or an
idiot).

first, i had to figure out which disk it was, this turned out to be
pretty easy. looking at `/proc/mdstat` i knew it was `/dev/sde1` that
had failed. then i looked in `dmesg` and found it was the western
digital. so that made it easy.

i opened up the case (while leaving everything still powered on and
running), unplugged the WD disk, pulled it out, replaced it with the new
disk.

surprisingly when i went back to my desktop, `/dev/sde` was the new disk
and was completely functional. i opened up `cfdisk` added a new
partition which i left as *linux*. since it was going to be put into a
raid, i figured the type didn't matter (i'm also unsure if i even need
to add a partition for linux software raids).

all that was left was adding it to the raid:

    sudo mdadm /dev/md1 -a /dev/sde1

and in about 4 minute's time, i was already syncing.
