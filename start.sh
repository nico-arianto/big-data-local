function checkJava() {
    if [ "$JAVA_HOME" = "" ]; then
        echo "JAVA_HOME environment variable is missing"
        exit 12
    fi
}

function startHadoop() {
    echo "Format the filesystem"
    hdfs namenode -format
    echo "Start NameNode daemon and DataNode daemon"
    start-dfs.sh
    echo "Make the HDFS directories required to execute MapReduce jobs"
    hdfs dfs -mkdir /user
    hdfs dfs -mkdir /user/$USER
    echo "Start ResourceManager daemon and NodeManager daemon"
    start-yarn.sh
}

USER="$(id -u -n)"

checkJava
startHadoop
