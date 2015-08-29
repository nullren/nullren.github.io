---
layout: post
title: spark quick start issues
---

so it seems that when you try to follow spark's quick start guide for
[self contained applications][1], it works pretty well **ONLY IF**
your spark executor is running locally.

basically, all resources need either have the same paths locally on
each and every executor, or they need to be accessible through any
storage method supported by Hadoop. currently, i run into a problem
where the remote executors fail to run the spark program because they
cannot find the file i pass to `textFile`.

so, time to add HDFS to mesos.

  [1]: http://spark.apache.org/docs/latest/quick-start.html#self-contained-applications
