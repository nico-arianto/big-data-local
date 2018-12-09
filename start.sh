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

function startHive() {
    echo "Make the HDFS directories before can create a table in Hive"
    hadoop fs -mkdir /tmp
    hadoop fs -mkdir /user/hive/warehouse
    hadoop fs -chmod g+w /tmp
    hadoop fs -chmod g+w /user/hive/warehouse
    # schematool -dbType derby -validate
    # if [ "$?" = "0" ]; then
    #     schematool -dbType derby -initSchema
    # fi
}

USER="$(id -u -n)"

checkJava
startHadoop
