---
layout: post
title: spark partitions and tasks
---

Just a small note about partitions of parallelized data and how they
manifest as tasks.

To quote [their documentation][1].

> Spark will run one task for each partition of the cluster. Typically
> you want 2-4 partitions for each CPU in your cluster.

So, how is this important?

Take for example the SparkPi demo.

```scala
def dart(i: Int): Int = {
  val x = Math.random()
  val y = Math.random()
  if (x*x + y*y < 1) 1 else 0
}

def estimatePi(N: Int, P: Int): Double = {
  val count = sc.parallelize(1 to N, P).map(dart).reduce(_ + _)
  4.0 * count / N
}
```

If we were to run `parallelize` with just our array and did not
specify partitions, we may only end up with 8 or very few partitions.

This may or may not be desirable.

Having many smaller partitions is desirable in the sense that each
task is smaller and if we scale Mesos up or down during this job, the
tasks that are lost during the transition are easily picked up
somewhere else. Whereas, if the number of partitions were very small,
losing a task could be a huge waste of energy.

Just food for thought.

  [1]: https://spark.apache.org/docs/latest/programming-guide.html#parallelized-collections
