---
layout: post
title: "spark: Initial job has not accepted any resources; check your cluster UI to ensure that workers are registered and have sufficient memory."
---

when running spark in a mesos cluster, i was banging my head on the
table wondering why i kept getting this error "Initial job has not
accepted any resources; check your cluster UI to ensure that workers
are registered and have sufficient memory". this was really
frustrating because each worker had 4gb of ram.

turns out, spark requires offers from workers to have twice the amount
of cpu a spark task wants. so, if you have a bunch of 1 cpu mesos
slaves, then you're gonna see this error.

this little gem inside spark's mesos scheduler
(MesosSchedulerBackend.scala) which explained it:

    // TODO(pwendell): Should below be 1 + scheduler.CPUS_PER_TASK?
    (mem >= MemoryUtils.calculateTotalMemory(sc) &&
      // need at least 1 for executor, 1 for task
      cpus >= 2 * scheduler.CPUS_PER_TASK) ||
      (slaveIdsWithExecutors.contains(slaveId) &&
        cpus >= scheduler.CPUS_PER_TASK)

lovely -________________-
