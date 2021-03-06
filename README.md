# Big Data in Local
Big Data Automation in Local MacOS

# Prerequisites
* Java 8
* Python 2.7 / 3

# Web UI
* NameNode: http://localhost:50070/
* ResourceManager: http://localhost:8088/
* Alluxio master: http://localhost:19999/
* Alluxio worker: http://localhost:30000/
* Livy: http://localhost:8998/ui
* HBase HMaster: http://localhost:16010/
* Presto: http://localhost:8080/ui/

# How to install
```shell
$ ./install.sh
```

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
* Alluxio: https://www.alluxio.org/docs/1.8/en/
* PostgreSQL: https://www.postgresql.org/docs/manuals/
* Hive: https://cwiki.apache.org/confluence/display/Hive/
* Spark: http://spark.apache.org/docs/latest/
* Livy: https://livy.incubator.apache.org/get-started/
* ZooKeeper: https://zookeeper.apache.org/doc/current/
* HBase: https://hbase.apache.org/book.html
* Phoenix: https://phoenix.apache.org/
* Kafka: http://kafka.apache.org/documentation/
* Presto: https://prestodb.github.io/docs/current/index.html
* Cassandra: https://cassandra.apache.org/doc/latest/

# Tested with
* hadoop 2.7.7
* tez 0.9.1
* alluxio 1.8.1
* postgresql 11.2-1
* hive 2.3.3
* spark 2.4.3
* livy 0.5.0
* zookeeper 3.4.13
* hbase 1.4.9
* phoenix 4.14.1
* kafka 2.1.0
* presto 0.217
* cassandra 3.11.4
