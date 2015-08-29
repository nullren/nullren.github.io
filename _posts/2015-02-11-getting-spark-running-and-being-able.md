---
layout: post
title: getting spark running and being able to submit jobs
---

mesos seems a little fragile at the moment, but i was able to add a
few machines to the mesos cluster. after having them mostly configured
correctly, i tried submitting spark jobs using the prebuilt binaries
from spark's website.

after downloading `spark-1.2.1-bin-hadoop2.4.tgz`, i continued.

there are two important things to note. first, you must provide a uri
for mesos slaves to grab the spark binary. i just copied the same
tarball i downloaded from spark's website and put it on my local
webserver.

second, spark will take the user executing the spark job and ask all
the machines on remove slaves to execute their jobs using the same
user. this is like... really dumb. since all the mesos-slaves are
running as `root`, it is easy enough to submit the spark job as `root`
which is what i did.

after extracting the tarball and entering it, i created two files,
`spark-defaults.conf` and `spark-env.sh`. inside `spark-defaults.conf`
i had to provide the uri to my tarball. this can be the uri you used
to initially download the tarball, but keeping it local will keep
things fast.

    spark.executor.uri http://rbrunspc/spark-1.2.1-bin-cdh4.tgz

then inside `spark-evn.sh` i had to set an environment variable to let
spark find my mesos library.

    export MESOS_NATIVE_LIBRARY=/usr/lib/libmesos.so

then i was able to execute the following command

    time sudo ./bin/spark-submit \
      --class org.apache.spark.examples.SparkPi \
      --master mesos://zk://ctest1:2181,ctest2:2181,ctest3:2181/mesos \
      lib/spark-examples*.jar \
      1000 \
      2>&1 | tee ~/spark.log

it worked! but, i've still got issues pending with adding slaves to
the mesos cluster. so far, it has been pretty easy. but then i tried
it with jiho's computer and his refused to play nicely. work to be
done figuring out why.

