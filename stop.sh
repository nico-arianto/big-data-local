function stopHadoop() {
    echo "Stop ResourceManager daemon and NodeManager daemon"
    $HADOOP_HOME/sbin/stop-yarn.sh
    echo "Stop NameNode daemon and DataNode daemon"
    $HADOOP_HOME/sbin/stop-dfs.sh
}

function stopPostgresql() {
    echo "Stop the PostgreSQL Database Server"
    pg_ctl stop -D $APPLICATION_DATA_DIR/postgresql
}

function stopAlluxio() {
    echo "Stop all Alluxio processes locally"
    alluxio-stop.sh local
}

function stopHive() {
    echo "Stop HiveServer2"
    local hiveserver2PidFile=/tmp/hiveserver2.pid
    kill $(cat $hiveserver2PidFile)
    rm $hiveserver2PidFile
    echo "Stop Metastore Server"
    local metastorePidFile=/tmp/hivemetastore.pid
    kill $(cat $metastorePidFile)
    rm $metastorePidFile
}

function stopLivy() {
    echo "Stop Livy"
    livy-server stop
}

function stopZooKeeper() {
    echo "Stop ZooKeeper"
    zkServer.sh stop
}

function stopHBase() {
    echo "Stop HBase"
    stop-hbase.sh
}

function stopPhoenix() {
    echo "Stop Phoenix Query Server"
    queryserver.py stop
}

function stopKafka() {
    echo "Stop Kafka"
    kafka-server-stop.sh
}

function stopPresto() {
    echo "Stop Presto"
    launcher stop
}

DIR="${0%/*}"

source $DIR/environment.env

stopPresto
stopKafka
stopPhoenix
stopHBase
stopZooKeeper
stopLivy
stopHive
stopPostgresql
stopAlluxio
stopHadoop
