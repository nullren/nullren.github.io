---
layout: post
title: "nbc is still awful at the olympics"
category: 
tags: []
---

two years ago, i had trouble with nbc and the olympics finding a
service called "tunlr". well, nbc still sucks. so i was considering my
options. one of them being, i wanted to use tunlr again. but instead
of using tunlr, i wanted to make my own service to do something
similar. using a vpn would make this easy, and if i cannot get it to
work well, at least i have a vpn to use.

so, i found a [neat
guide](https://github.com/corporate-gadfly/Tunlr-Clone) that explained
how to this. it is pretty clever and much simpler than what i imagined
would be required.

running this one just one machine, instead of setting up a dns server,
i just used my `/etc/hosts` file.  everything worked as expected
except a couple things.

the biggest obstacle was the fact that the sites i wanted to use used
region locked cdn sources. typically, the cdn would not care where you
are from, they are just serving content. so, making the website think
you are local and giving you access to the cdn would mean not having
to run the cdn stream through a vpn. but being region locked, this is
not possible. so making my own tunlr clone would not benefit me at
all.

i did get iplayer to work just fine, so maybe i can do a little more
with that later on. i ended up just using the vpn as normal to watch
cbc streams of the olympics this year.
