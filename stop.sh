function stopHadoop() {
    echo "Stop ResourceManager daemon and NodeManager daemon"
    stop-yarn.sh
    echo "Stop NameNode daemon and DataNode daemon"
    stop-dfs.sh
}

stopHadoop
