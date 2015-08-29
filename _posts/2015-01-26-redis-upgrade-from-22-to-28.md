---
layout: post
title: redis upgrade from 2.2 to 2.8 (and beyond)
---

what initially started as a trivial task quickly turned into a test of
patience and debugging. currently, i am still in a step of debugging.

to start with upgrading, i wanted to reuse the redis config we had
previously trying to keep things as close to what was in production as
possible. there were a few settings that had become deprecated, so i
removed them.

## first deployment

we deployed the upgraded redis and immiately saw problems.

we have five redis servers in production (redis0, ..., redis4). after
upgrading, the issues we observed were seeing waves of exceptions. things
would run fine, then after a little bit, everything would not. this
would repeat.

first thing i looked into was memory usage. when we upgraded, we had to
trim some settings out of the configuration file since they were
deprecated. the first time around, we cut out all the virtual memory
settings.

so to test this hypothesis, i had set up a redis server with the same
config and bombarded it with requests. redis, by default, will try to
use up all the available memory. this is good and bad. it is good in
that all your resources are used, it is bad in that too many are used.

when redis would fork to write the snapshot to the disk, it would
begin swapping because there was no memory available. this was surely
the problem. i saw the same waves of exceptions and easily enough
there is a setting in redis called `maxmemory` which limits the amount
of memory redis will allocate.

there were no more waves of exceptions that i observed in testing
anymore.

## second deployment

take two. deployed the updated redis config. instead of seeing waves
of exceptions, i was now seeing waves of lag. large amounts of lag.

a small utility i had set up would time itself performing 1000
operations against redis. typically this takes about 100-300 ms.
after deployment, this would have surges up to 10000 ms.

commence head banging.

## testing

i found a way to effectively stress a redis server in the office and
enabled latency monitoring as well as enabling a slowlog. coupling
with the poormansprofiler, i am getting a little closer to figuring
out what is going on.

it seems that whenever the redis server hangs/blocks/waits a little
too long, it dumps all the connections when it returns. this can
easily be seen by doing somethign like `kill -STOP $pid; sleep 2; kill
-CONT $pid`. so any time there is a long blocking operation, all the
connections get dumped. as to why they get dumped, that seems to be
more of a redis internals issue possibly worth looking into. but the
bigger issue is to not have long blocking operations to begin with.

a few places we could experience long blocking operations are key
expiration and evictions, also during forking and writing to the disk.
there are ways to mitigate the effects of these.

## wat

before trying to optimize, i wanted to compare the currently running
version, 2.2.8. so i started it up with the config we typically use in
production.

its performance was abismal on the machine i tested it with. i found
this to be really frustrating.

## updates

i'll continue to post updates. but for now, i think the plan is to
continue with testing the new version and optimizing it as best i can.

eventually, i'll need to just plan to test either on site b or even do
live testing in production.

## more updates

one thing i have learned recently that was surprising was that, due to
redis' single-threaded nature, it is possible for both redis and
processing network input can end up on the same core. if this happens,
then things can get abismally slow. i am going to test this.


