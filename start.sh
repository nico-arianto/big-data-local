function checkJava() {
    if [ "$JAVA_HOME" = "" ]; then
        echo "JAVA_HOME environment variable is missing"
        exit 12
    fi
}

function startHadoop() {
    echo "Format the filesystem"
    hdfs namenode -format
    start-dfs.sh
    hdfs dfs -mkdir /user
    hdfs dfs -mkdir /user/$USER
    start-yarn.sh
}

USER="$(id -u -n)"

checkJava
startHadoop
