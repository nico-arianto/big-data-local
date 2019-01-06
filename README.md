# Big Data in Local
Big Data Automation in Local MacOS

# Web UI
* NameNode: http://localhost:9870/
* ResourceManager: http://localhost:8088/
* Alluxio master: http://localhost:19999
* Alluxio worker: http://localhost:30000

# How to install
Install the Big Data components via Homebrew
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

# References
* Homebrew: https://brew.sh/
* Hadoop: https://hadoop.apache.org/docs/current3/
* Hive: https://cwiki.apache.org/confluence/display/Hive/Home
* Alluxio: https://www.alluxio.org/docs/1.8/en/Getting-Started.html
* Derby: https://db.apache.org/derby/docs/10.14/getstart/
* Coreutils: https://www.gnu.org/software/coreutils/

# Tested with
* hadoop 3.1.1
* hive 3.1.1
* apache-spark 2.4.0
* alluxio 1.8.1
