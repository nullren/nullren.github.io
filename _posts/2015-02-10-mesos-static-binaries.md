---
layout: post
title: mesos static binaries
---

trying to experiment with creating mesos static binaries. being able
to do this would allow me and others to create a single binary and run
it on many different machines without needing to worry about having
the correct libraries installed.

i experimented with just adding `-static` to `LDFLAGS` and trying to
build mesos, but it fails with not being able to link libcurl. so this
is going to be a bit of work. might be better to just not bother.
