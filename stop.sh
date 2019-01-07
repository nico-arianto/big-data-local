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

function stopHbase() {
    stop-hbase.sh
}

stopHbase
stopHive
stopAlluxio
stopHadoop
