function startHadoop() {
    echo "Format the filesystem"
    hdfs namenode -format -nonInteractive
    echo "Start NameNode daemon and DataNode daemon"
    start-dfs.sh
    echo "Make the HDFS directories required to execute MapReduce jobs"
    hdfs dfs -mkdir -p /user/$USER
    echo "Start ResourceManager daemon and NodeManager daemon"
    start-yarn.sh
}

function startHive() {
    echo "Make the HDFS directories before can create a table in Hive"
    # init-hive-dfs.sh
    hadoop fs -mkdir /tmp
    hadoop fs -mkdir -p /user/hive/warehouse
    hadoop fs -chmod g+w /tmp
    hadoop fs -chmod g+w /user/hive/warehouse
    echo "Start Derby server"
    brew services start derby
    echo "Waiting for Derby server to start"
    gtimeout 60 sh -c 'until nc -z $0 $1; do printf "." && sleep 1; done;' localhost 1527
    echo "Try Schema upgrade"
    schematool -dbType derby -upgradeSchema
    if [ ! "$?" = "0" ]; then
        echo "Try Schema initialization"
        schematool -dbType derby -initSchema
    fi
}

DIR="${0%/*}"
USER="$(id -u -n)"

source $DIR/environment.sh

startHadoop
startHive
