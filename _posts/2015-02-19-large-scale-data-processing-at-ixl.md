---
layout: post
title: large scale data processing at IXL and how to make it happen
---

# Design Doc: Large-Scale Data Processing

*-rbruns*

-----------------------------------------------------------

## Overview

Spark is a framework to parallelize many computations across many
compute resources easily. Spark can run on top of Mesos which is a
framework that makes allocating compute resources very easy. All of
these frameworks can coordinate with Zookeeper to provide service
discovery and high availability. This design discusses using Spark on
top of Mesos coordinated through Zookeeper.

-----------------------------------------------------------

## Business Needs

Imeh and Eduardo need to process a ton of data as quickly and
efficiently as possible.

-----------------------------------------------------------

## Design

We have a lot of compute power. Peak traffic hours, most machines are
pretty well utilized, but during "off hours", many of those machines
sit idle with plenty of compute time going to waste.

With our current infrastructure, adding new machines to run a single
dedicated task is becoming expensive and inefficient. Especially to
meet our current business needs and unknown future business needs, we
must be much more flexible.

One framework, Spark, allows a developer to spread expensive
computations over to worker nodes in a Spark cluster. This is
mandatory if we want to reach our data processing goals within any
reasonable amount of time.

However, Spark by itself is not a very flexible framework. It is
possible to create a single Spark cluster, but resizing it dynamically
is not a trivial task. Also, should we ever consider to run a second
framework like Storm, it would require setting up a second cluster.

Apache Mesos is a generalized compute cluster framework that allows
other frameworks like Spark, Storm, and many others including Hadoop
to piggy back off of to allocate compute resources. Mesos is easy to
scale and contract to allow including more compute resources to the
Mesos cluster as machines become idle and removing them when they are
not needed.

### Terminology

This section is better to be quoted directly from the [Mesos white
paper][4].

> Mesos consists of a *master* process that manages *slave* daemons
> running on each cluster node, and *frameworks* that run *tasks* on
> these slaves.
> 
> The master implements fine-grained sharing across frameworks using
> *resource offers*. Each resource offer contains a list of free
> resources on multiple slaves.  The master decides how many resources
> to offer to each framework according to a given organizational
> policy, such as fair sharing, or strict priority. To support a
> diverse set of policies, the master employs a modular architecture
> that makes it easy to add new allocation modules via a pluggin
> mechanism. To make the master fault tolerant we use ZooKeeper...to
> implement the failover mechanism...
> 
> A framework running on top of Mesos consists of two components: a
> *scheduler* that registers with the master to be offered resources,
> and an *executor* process that is launched on slave nodes to run the
> framework’s tasks.  While the master determines how many resources
> are offered to each framework, the frameworks’ schedulers select
> which of the offered resources to use. When a frameworks accepts
> offered resources, it passes to Mesos a description of the tasks it
> wants to run on them. In turn, Mesos launches the tasks on the
> corresponding slaves.

### Mesos

Review [Mesos architecture][12].

![Mesos architecture][13]

![Mesos resource offers][14]

-----------------------------------------------------------

### Assumptions

These are some of the assumption I have made when setting up Mesos.

#### Service Discovery

If you want Mesos master servers to run with any sort of High
Availability, Zookeeper is required. This also simplifies
configuration because you can point every framework to Zookeeper to
find the Mesos cluster. However, it is possible to run Mesos without
Zookeeper. Mesos only operates with a single master server; there is
no sharding or clustering capability within it itself. However, HA
could be implemented with clever use of HA Proxy and DNS switching.

#### Name Discovery

Some form of name resolution exists, either with DNS or `/etc/hosts`
files. This is especially important when you wish to navigate the
Mesos web UI or use Spark. Most frameworks require a hostname or IP
that can resolve to a hostname (this includes Spark), also no hostname
can resolve to 127.0.0.1.

#### Choice of Distro

To build Mesos from source, you need a distribution of linux that
ships with GCC that implements C++11. There are also a list of
dependencies, the best example of these are listed as Ubuntu
dependencies in [their Dockerfile][1]. All of these have analogues for
CentOS and Fedora operating systems. Precompiled packages for Ubuntu
and CentOS (which is what I used) [exist from Mesosphere][2].

#### Installed Services and Software

All machines have Docker and some version of Java installed with the
`JAVA_HOME` either provided at boot time or installed to a standard
location.

#### IPTables

All machines have `iptables` completely flushed and allowing all
traffic.

The reason for this is that many ports are randomly assigned,
especially in Spark. It can be configured to use a particular port,
but then ports for the Mesos slaves are also randomly assigned for
each task.

Spark will also make available jars required for a task via http to
all the slaves, so this is just another port that needs to be
available.

-----------------------------------------------------------

### Installation

First draft at installing Mesos and configuring Spark.

#### Mesos Master

To install mesos, the assumption made was that we are using a linux
distrubution that has a pre-compiled package [available from
Mesosphere][2], in particular CentOS.

First set up the repository.

    sudo rpm -Uvh http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm

Then install `mesos`.

    sudo yum install -y mesos

We can run Mesos master directly supplying command line arguments
which looks something like:

    mesos-master --zk=zk://ctest1:2181,ctest2:2181,ctest3:2181/mesos \
      --work_dir=/var/lib/mesos --quorum=1 --log_dir=/var/log/mesos \
      --port=5050

Configuring `mesos`, we need to tell it where to find zookeeper.
Create a file `/etc/mesos/zk` with the contents:

    zk://ctest1:2181,ctest2:2181,ctest3:2181/mesos

Replace with the appropriate Zookeeper servers.

There is a second option, `/etc/mesos-master/quorum`. This number must
be configured correctly to ensure the master log is replicated to
backup servers. If there are `n` Mesos master servers, then `quorum`
must be set to `n/2 + 1`, eg if there are 3 Mesos masters, then quorum
must be `2`. The default value is `1`.

#### Mesos Slave

The install process is identical to that of the Master Master. We will
add one extra change to the configuration and it is setting the
`containerizers` flag to be `docker,mesos`.

These Mesos slaves will also be running Spark jobs, so they have some
extra required software. They must have Java (or a `JAVA_HOME` set)
installed, as well as Docker.

    sudo yum install -y docker java-1.7.0-openjdk-devel

Ensure Docker is running.

    systemctl enable docker
    systemctl start docker

Then we can run Mesos slave directly with

    mesos-slave --master=zk://ctest1:2181,ctest2:2181,ctest3:2181/mesos \
      --containerizers=docker,mesos --log_dir=/var/log/mesos \
      --work_dir=/var/run/mesos

Otherwise, it can be configured similar to the master using config
files if you installed the CentOS package and managed by `systemd`.
This is done by writing into the file
`/etc/mesos-slave/containerizers`

    docker,mesos

Now we enable and start both `docker` and `mesos-slave`.

    systemctl enable mesos-slave
    systemctl start mesos-slave

#### Spark

Download a Spark [binary tarball][9]. There are many prebuilt
tarballs, but any of them will work.i This will be required to run the
Spark driver which will launch the Spark context and run tasks on the
Mesos slaves.

Spark jobs must be submit locally from the view of the
Spark drivers.

Inside the extracted tarball, there are two files the need to be
configured inside the `conf` directory: spark-defaults.conf and
spark-env.sh.

Inside `spark-defaults.conf`, we need to add an option that can tell
the Mesos slaves where to find the master and where to download a
Spark binary tarball.

    spark.master mesos://zk://ctest1:2181,ctest2:2181,ctest3:2181/mesos
    spark.executor.uri http://path/to/same-tarball-downloaded.tgz

Then `spark-env.sh` needs to export an evironment variable telling
Spark where it can find the Mesos native library.

    export MESOS_NATIVE_LIBRARY=/usr/lib/libmesos.so

Now this should be enough to submit a sample job to the Mesos cluster.

    ./bin/spark-submit \
      --class org.apache.spark.examples.SparkPi
      lib/spark-examples*.jar 10

##### Spark Coarse-Grained Mode on Mesos

Inside the `spark-defaults.conf` file, you can set an option for
coarse-grained mode in spark. This will have Spark use all cpus
offered by mesos immediately. By default, Spark runs in fine-grained
mode, where each Spark task is a single Mesos task and resources get
used fairly but has a little overhead. This is explained more in the
[Spark documentation][11].

-----------------------------------------------------------

### Availability and Resilience

The Mesos [white paper][4] can better describe how they maintain Mesos
master availability:

> Since all the frameworks depends on the master, it is critical to
> make the master fault-tolerant. To achieve this we use two
> techniques. First, we have designed the master to be soft state,
> i.e., the master can reconstruct completely its internal state from
> the periodic messages it gets from the slaves, and from the
> framework schedulers. Second, we have implemented a hot-standby
> design, where the master is shadowed by several backups that are
> ready to take over when the master fails. Upon master failure, we
> use ZooKeeper [4] to select a new master from the existing backups,
> and direct all slaves and framework schedulers to this master.
> Subsequently, the new master will reconstruct the internal state
> from the messages it receives from slaves and framework schedulers.

Reconstructing the state depends on our choice of the value for
`quorum`. To be able to fully reconstruct the state, `quorum` must be
larger than half the number of master servers.

The Mesos slaves are also resilient in that they're each expendable.
If a Mesos slave dies while running a task, it gets marked as "Lost"
in the Mesos master and that task will eventually get rescheduled to
run on another machine.

#### Zookeeper

Since we are using Zookeeper to coordinate everything, it is
imperative that it is running. Otherwise slaves will not know who the
leading master is and so they will not get any tasks to run.

-----------------------------------------------------------

## Open Questions and Problems

Mesos is very powerful and can provide ways to not only run
computational frameworks like Spark and Hadoop, but can run general
tasks and even services inside Docker containers. This means you can
use Mesos to coordinate running services like Cassandra, Redis, and
even web application servers like Tomcat.

There is also a framework called Chronos which essentially lets you
run distributed cron jobs.

### Spark Rejecting Resources

Spark will reject offers from Mesos if the number of CPUs a Spark task
requires (by default `1`) is less than half the available CPUs on a
Mesos slave.

This is something that was not clearly documented, but should not be
an issue if using Mesos slaves that have at least 2 CPUs. Just good to
keep in mind.

### Slave Recovery

Still an open problem. For especially long jobs, slave recovery from
accidental mesos termination may become something very important.
There is a plan for [Slave Recovery in Mesos][7] and can be
configured. However, a Mesos slave can only recover if the executor
and tasks were continuing to run. A server reboot, for example, would
not be recovered.

### Networking

If running services over Mesos, one problem is handling NAT or any
other networking. Some frameworks exist to help tackle this like
[Flannel][3] as part of CoreOS, also there is Kubernetes and in the
near future Mesophere DCOS.

### Will Mesos be around?

Despite there having been an explosion of frameworks to run on top of
Mesos, another problem is finding which one will persist and be used
one year from now, two years from now, forever?

### Non-root Users

To use an unprivileged (non-`root`) user, eg `mesos`, there are a few
considerations that need to be made. An open problem is determining
the best method of handling this situation. There was a point where if
the Spark driver, unconfigured for users, after submitting a job to
Mesos, would see all the jobs fail because they were attempting to run
the jobs under the same user as the one who submitted the job
initially, eg `rbruns`. Not every machine had this user, so those jobs
failed.

So through out most of this testing, I was certain the `root` user
existed on every machine and that was what was used. Using another
user we could just need to ensure all machines have the same user and
all Spark jobs are submitted for that user.

### Logging

Because many tasks will be running on randomly assigned servers, Mesos
provides a rudimentary method of viewing logs, but a more robust
system of remote logging would be preferred.

### Shared Storage

Currently, Spark cannot reference any files inside a Spark job. If a
Spark job references a local file, every Mesos Slave must have the
same file at the same path specified in the Spark job. This is not
very practical, so using some sort of shared storage is preferred.

There are an abundance of ways to accomplish this though the preferred
methods seem to be HDFS or S3. Luckily, there is a way to easily set
up [HDFS over Mesos][10].


  [1]: https://github.com/apache/mesos/blob/master/Dockerfile
  [2]: https://mesosphere.com/downloads/details/index.html
  [3]: https://coreos.com/blog/introducing-rudder/
  [4]: http://mesos.berkeley.edu/mesos_tech_report.pdf
  [5]: http://mesos.apache.org/documentation/latest/operational-guide/
  [6]: http://mesos.apache.org/documentation/latest/high-availability/
  [7]: https://mesos.apache.org/blog/slave-recovery-in-apache-mesos/
  [8]: http://cs.berkeley.edu/~matei/papers/2010/hotcloud_spark.pdf
  [9]: https://spark.apache.org/downloads.html
  [10]: https://github.com/brugidou/hdfs-mesos
  [11]: http://spark.apache.org/docs/latest/running-on-mesos.html#mesos-run-modes
  [12]: https://mesos.apache.org/documentation/latest/mesos-architecture/
  [13]: /images/mesos_arch_1.jpg
  [14]: /images/mesos_arch_2.jpg
