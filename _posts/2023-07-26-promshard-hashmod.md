---
layout: post
title: "promshard hashmod"
category:
tags: []
---

```shell
# usage: promshard $total_shards $host_name
#
# just paste this function in your shell or add it to your ~/.profile

promshard() {
  echo -n "$2" | md5sum | cut -c 17-32 | tr 'a-z' 'A-Z' | xargs -I {} echo 'ibase=16; {}' | bc | xargs -I {} echo "{} % $1" | bc
}
```

a while back, i was trying to debug some metrics that were scraped by a prometheus server. at work, we have many sharded clusters of prometheus and the way sharding works is that prometheus takes a full list of known hosts and then hashes each of the hosts. you tell prometheus how many shards there are and what number shard it is and using that info, it compares the hash modulo number of shards with the number of the shard. if they're the same, that host gets scraped.

i wanted a simple bit of code to run this myself and luckily [the actual logic to do that in prometheus](https://github.com/prometheus/prometheus/blob/6f7a0210e71847bd61590e974ebb6885868a6a53/model/relabel/relabel.go#L271-L275) is very simple. the snippet above is a little bash-friendly function for doing it, too.
