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

# How to set the environment
```shell
$ source ./environment.env
```

# References
* Hadoop: https://hadoop.apache.org/docs/r2.7.7/
* Tez: https://cwiki.apache.org/confluence/display/TEZ/
* Hive: https://cwiki.apache.org/confluence/display/Hive/
* Alluxio: https://www.alluxio.org/docs/1.8/en/
* HBase: https://hbase.apache.org/book.html
* Phoenix: https://phoenix.apache.org/
* Kafka: http://kafka.apache.org/documentation/
* Derby: https://db.apache.org/derby/docs/10.14/

# Tested with
* hadoop 2.7.7
* Tez 0.9.1
* derby 10.14.2.0
* hive 3.1.1
* apache-spark 2.4.0
* alluxio 1.8.1
* hbase 1.4.9
* phoenix 4.14.1
* kafka 2.1.0
