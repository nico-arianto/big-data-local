function stopHadoop() {
    echo "Stop ResourceManager daemon and NodeManager daemon"
    stop-yarn.sh
    echo "Stop NameNode daemon and DataNode daemon"
    stop-dfs.sh
}

function stopAlluxio() {
    echo "Stop all Alluxio processes locally"
    alluxio-stop.sh local
}

function stopHive() {
    echo "Stop HiveServer2"
    kill $(cat /tmp/hive2/pid)
    brew services stop derby
}

function stopZookeeper() {
    # brew services stop zookeeper
    zkServer stop
}

function stopHbase() {
    # brew services stop hbase
    stop-hbase.sh
}

stopHbase
stopZookeeper
stopHive
stopAlluxio
stopHadoop
