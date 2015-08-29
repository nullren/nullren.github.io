---
layout: post
title: redis sentinel quickstart
---

Redis sentinel is a neat process that actively monitors its redis
master server and will automatically promote any of the slaves to
master if a failover is triggered.

It will also remember the old master and turn it into a slave of the
new master when it ever comes back up.

For actually learning about sentinel and its configuration, the [redis
documentation][1] was not awful.

For my purposes, I wanted three sentinel servers so that I could have
a quorum of two.

Each config looked something like

```
port 23460
sentinel monitor mymaster ::1 23450 2
sentinel down-after-milliseconds mymaster 1000
sentinel failover-timeout mymaster 10000
sentinel config-epoch mymaster 6
```

The most important lines were setting the port (which can be
overwritten by the command line), as well as telling it which master
to monitor.

Sentinel servers only need to be told of the current master server,
from there they can find other sentinel servers as well as any slaves.

So, I would start up a couple instances of redis

```
redis-server --port 23450
redis-server --port 23451
```

Then I would tell 23451 to slave 23450 with

```
redis-cli -h ::1 -p 23451 slaveof ::1 23450
```

Using the config above for sentinel, I would start sentinel just by
running

```
redis-sentinel sentinel-23460.conf
```

I had similar configs but only changed the ports to 23461 and 23462
and started each of those.

```
redis-sentinel sentinel-23461.conf
redis-sentinel sentinel-23462.conf
```

Now when I stop the redis server on 23450, I can see the sentinels
agreeing it is down and promoting the slave to master. When I started
the old master back up again, I could see it being added as a slave to
the new master.

Similarly, the sentinels could see when new slaves were added.
