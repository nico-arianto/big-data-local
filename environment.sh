export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export HADOOP_HOME=/usr/local/opt/hadoop/libexec
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
# hive-config.sh
export HIVE_HOME=/usr/local/opt/hive/libexec
export HIVE_CONF_DIR=$HIVE_HOME/conf
# find-spark-home
export SPARK_HOME=/usr/local/opt/apache-spark/libexec
export SPARK_CONF_DIR=$SPARK_HOME/conf
export ALLUXIO_HOME=/usr/local/opt/alluxio/libexec
# hbase-config.sh
export HBASE_HOME=/usr/local/opt/hbase/libexec
export HBASE_CONF_DIR=/usr/local/opt/hbase/libexec/conf
