# Big Data in Local
Big Data Automation in Local MacOS

# Web UI
* NameNode: http://localhost:50070/
* ResourceManager: http://localhost:8088/
* Alluxio master: http://localhost:19999/
* Alluxio worker: http://localhost:30000/
* HBase HMaster: http://localhost:16010/

# How to setup
Override the Big Data components configuration files
```shell
$ ./setup.sh
```

# How to start
```shell
$ ./start.sh
```

# How to stop
```shell
$ ./stop.sh
```

# References
* Hadoop: https://hadoop.apache.org/docs/r2.7.7/
* Hive: https://cwiki.apache.org/confluence/display/Hive/
* Alluxio: https://www.alluxio.org/docs/1.8/en/
* HBase: https://hbase.apache.org/book.html
* Derby: https://db.apache.org/derby/docs/10.14/

# Tested with
* hadoop 2.7.7
* derby 10.14.2.0
* hive 3.1.1
* apache-spark 2.4.0
* alluxio 1.8.1
* hbase 2.1.2
