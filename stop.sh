function stopHadoop() {
    echo "Stop ResourceManager daemon and NodeManager daemon"
    stop-yarn.sh
    echo "Stop NameNode daemon and DataNode daemon"
    stop-dfs.sh
}

function stopHive() {
    kill $(cat /tmp/hive2/pid)
    brew services stop derby
}

stopHive
stopHadoop
