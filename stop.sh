function stopHadoop() {
    echo "Stop ResourceManager daemon and NodeManager daemon"
    $HADOOP_HOME/sbin/stop-yarn.sh
    echo "Stop NameNode daemon and DataNode daemon"
    $HADOOP_HOME/sbin/stop-dfs.sh
}

function stopDerby() {
    echo "Stop the Derby Network Server"
    source setNetworkServerCP
    java org.apache.derby.drda.NetworkServerControl shutdown
}

function stopAlluxio() {
    echo "Stop all Alluxio processes locally"
    alluxio-stop.sh local
}

function stopHive() {
    echo "Stop HiveServer2"
    local pidFile=/tmp/hiveserver2.pid
    kill $(cat $pidFile)
    rm $pidFile
}

function stopZooKeeper() {
    echo "Stop ZooKeeper"
    zkServer.sh stop
}

function stopHBase() {
    echo "Stop HBase"
    stop-hbase.sh
}

DIR="${0%/*}"

source $DIR/environment.env

stopHBase
stopZooKeeper
stopHive
stopAlluxio
stopDerby
stopHadoop
