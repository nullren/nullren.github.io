---
layout: post
title: "recreating tunlr"
category: 
tags: [vpn,rawr,win,linux]
---

a long time ago, i wanted to watch the bbc because nbc olympics was
just terrible. i did not want a vpn because then it would force all my
video streams to get piped through the vpn as well. i found a service
called "tunlr" which is still around. when i first started using it,
it was free, but then they moved onto a subscription service. (oddly
enough, it is free again.)

tunlr was really simple, all you did was change your dns servers and
everything afterwards was handled. no vpn software or further
configuration required. i really liked it and i wanted to make my own.
[this guide on
github](https://github.com/corporate-gadfly/Tunlr-Clone) gave really
good hints on how i could accomplish it.

the hardest part was trying to find a machine located inside the
region i wanted to watch videos from. after looking around for cheap
VPSs, i realized that was dumb and bought a VPN instead. now, i had a
way to reach into not one, but 40-something countries.

to recreate tunlr, the idea was to create many vm servers, each
running a vpn client to one particular region---one machine for the
uk, one machine for canada, etc. then, i run another machine as the
dns server.

the dns server has a big list of all the streaming services i want to
access. i override their normal values with the addresses of the vpn
vms of the appropriate region. for instance `bbc.co.uk` points to the
ip of the uk vm.

on each of my vpn vms, i ran both `sniproxy` and `openvpn`, along with
a few choice `iptables` rules.

for the dns, right now, i am just using `dnsmasq` and keeping track of
the custom ips for different streaming services in `/etc/hosts`.
