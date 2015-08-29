---
layout: post
title: quick set up history for submitting a spark job
---

just a simple history to remind myself.

      1  ls
      2  tar xzvf spark-1.2.1-bin-cdh4.tgz 
      3  cd spark-1.2.1-bin-cdh4
      4  ls
      5  cd conf
      6  ls
      7  cp spark-defaults.conf.template spark-defaults.conf
      8  vim spark-defaults.conf
      9  vi spark-defaults.conf
     10  sudo yum install -y httpd && sudo systemctl start httpd
     11  cd ../..
     12  ls
     13  cp spark-1.2.1-bin-cdh4.tgz /var/www/html/
     14  sudo cp spark-1.2.1-bin-cdh4.tgz /var/www/html/
     15  cd spark-1.2.1-bin-cdh4/conf/
     16  vi spark-defaults.conf
     17  ls
     18  cp spark-env.sh.template spark-env.sh
     19  vi spark-env.sh
     20  cd ../
     21  ./bin/spark-submit --class org.apache.spark.examples.SparkPi lib/spark-examples*.jar 10
     22  history

only three config settings were added. inside `spark-default.conf`:

    spark.master         mesos://zk://zookeeper0:2181/mesos
    spark.executor.uri   http://submitter/spark-1.2.1-bin-cdh4.tgz

inside `spark-env.sh`:

    #!/bin/sh
    export MESOS_NATIVE_LIBRARY=/usr/lib/libmesos.so

happy day.
