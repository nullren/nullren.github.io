---
layout: post
title: key-value stores
---

This is a just a place-holder/note.

On my TODO list to look up a handful of different key-value stores.
There are a few new contenders in addition to a couple of old
favorites:

  * memcached
  * redis
  * ehcache
  * riak
  * couchbase

I am especially interested in looking into ehcache as well as riak.

Also, memcached (and couchbase) made this list because we may need to
re-evaluate how we are using redis. redis has a handful of good
features, like handling pub/sub, but we use none of it. We are
strictly looking only for a key-value store, eg ObjectManager.
