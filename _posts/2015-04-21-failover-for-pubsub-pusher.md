---
layout: post
title: failover for pubsub pusher
---

# Failover Ideas

This document provides a simple automated failover strategy for
dealing with Socket.IO applications backed by redis.

----------------------------------------------------------------------

## Redis and Redis Sentinel Backend

The actual redis service "holds" no data; as soon as something comes
in, it is immediately dispersed to all the subscribers and forgotten.

So, to failover, we need to swap out redis instances and reconnect all
subscribers. This is exactly what redis sentinel will do.

There is a redis master server and any non-zero number of redis slaves
to it. All messages published into the master get replicated to all
the slaves, and all subscribers on any of the redis servers will
receive the message. At the moment, only the master is actively used
by clients.

Redis sentinel is a service that will automatically promote a slave to
master if the master becomes unreachable for some reason. It will
demote the old master to a slave.

To remove unreachable machines from the sentinel list of slaves, you
must manually [send a command to do the pruning][1].

----------------------------------------------------------------------

## Socket.IO and Node.js Frontend

Each Node.js server can run independent from any other Node.js server.
This is because they each rely on redis to publish Socket.IO messages
appropriately. This is done through a Socket.IO Adapter
`socket.io-redis`.

Because we are actually using redis sentinel to find the redis master,
we had to alter the Socket.IO Adapter slightly by providing a redis
wrapper that handles sentinel. This wrapper is provided by the NPM
package `redis-sentinel`.

What is good about this wrapper is that it will force Socket.IO to
reconnect to redis if sentinel notices the redis master has failed and
failover has happened. There is a chance that messages passed during
this downtime will be lost.

### State and Sticky Sessions

Each node server holds very little state. The only state it does hold
is if there is a browser that cannot use websockets, and so socket.io
provides an alternative method (typically polling of some sort). This
requires a sticky-session load balancer. However, you can restrict
only websocket connections and then this requirement goes away.

### Nginx

Nginx was used to provide transparent loadbalancing/proxying to a
group of Node.js servers. Socket.IO even provided [example nginx
configuration][2] for proxying websockets.

If any should die and a websocket connection is lost, the Socket.IO
client code will force a reconnect which will get routed through Nginx
to find a Node.js server.

  [1]: http://redis.io/topics/sentinel#removing-the-old-master-or-unreachable-slaves
  [2]: http://socket.io/docs/using-multiple-nodes/#nginx-configuration
