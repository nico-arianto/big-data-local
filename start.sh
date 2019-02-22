function startHadoop() {
    if [ ! -d $HOME/Applications/var/hadoop ]; then
        echo "Format the filesystem"
        hdfs namenode -format -nonInteractive
    fi
    echo "Start NameNode daemon and DataNode daemon"
    $HADOOP_HOME/sbin/start-dfs.sh
    echo "Make the HDFS directories required to execute MapReduce jobs"
    hadoop fs -mkdir -p /user/$USER
    echo "Start ResourceManager daemon and NodeManager daemon"
    hadoop fs -test -d /apps/tez-$TEZ_VERSION
    if [ ! "$?" = "0" ]; then
        echo "Upload Tez tarball to HDFS"
        hadoop fs -mkdir -p /apps/tez-$TEZ_VERSION
        hadoop fs -copyFromLocal $APPLICATION_DIR/apache-tez-$TEZ_VERSION-bin/share/tez.tar.gz /apps/tez-$TEZ_VERSION
    fi
    $HADOOP_HOME/sbin/start-yarn.sh
}

function startDerby() {
    echo "Start the Derby Network Server"
    local systemHome=$HOME/Applications/var/data/derby
    local logDir=$HOME/Applications/var/log/derby
    mkdir -p $systemHome
    mkdir -p $logDir
    source setNetworkServerCP
    java -Dderby.system.home=$systemHome \
        org.apache.derby.drda.NetworkServerControl start \
        >$logDir/derby.out 2>$logDir/derby.err &
}

function startAlluxio() {
    echo "Format Alluxio master and all workers"
    alluxio format -s
    echo "Start all masters, proxies, and workers"
    alluxio-start.sh local SudoMount
}

function startHive() {
    echo "Make the HDFS directories before can create a table in Hive"
    hadoop fs -mkdir -p /tmp
    hadoop fs -mkdir -p /user/hive/warehouse
    hadoop fs -chmod g+w /tmp
    hadoop fs -chmod g+w /user/hive/warehouse
    echo "Try Schema upgrade"
    schematool -dbType derby -upgradeSchema
    if [ ! "$?" = "0" ]; then
        echo "Try Schema initialization"
        schematool -dbType derby -initSchema
    fi
    echo "Start HiveServer2"
    local hiveserver2LogDir=$HOME/Applications/var/log/hive/hiveserver2
    mkdir -p $hiveserver2LogDir
    nohup hiveserver2 >$hiveserver2LogDir/hiveserver2.out 2>$hiveserver2LogDir/hiveserver2.err & \
        echo $! > /tmp/hiveserver2.pid
    echo "Start Metastore Server"
    local metastoreLogDir=$HOME/Applications/var/log/hive/metastore
    mkdir -p $metastoreLogDir
    nohup hive --service metastore >$metastoreLogDir/hivemetastore.out 2>$metastoreLogDir/hivemetastore.err & \
        echo $! > /tmp/hivemetastore.pid
}

function startZooKeeper() {
    echo "Start ZooKeeper"
    zkServer.sh start
}

function startHBase() {
    echo "Start HBase"
    start-hbase.sh
}

function startPhoenix() {
    echo "Start Phoenix Query Server"
    queryserver.py start
}

function startKafka() {
    echo "Start Kafka"
    export LOG_DIR=$HOME/Applications/var/log/kafka
    nohup kafka-server-start.sh -daemon $KAFKA_HOME/config/server.properties
}

DIR="${0%/*}"

source $DIR/environment.env

startHadoop
startDerby
startAlluxio
startHive
startZooKeeper
startHBase
startPhoenix
startKafka
