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

function startAlluxio() {
    echo "Format Alluxio master and all workers"
    alluxio format -s
    echo "Start all masters, proxies, and workers"
    alluxio-start.sh local SudoMount
}

function startPostgresql() {
    echo "Start the PostgreSQL Database Server"
    local dataDir=$APPLICATION_DATA_DIR/postgresql
    local logDir=$APPLICATION_LOG_DIR/postgresql
    if [ ! -d $dataDir ]; then
        pg_ctl init -D $dataDir
        mkdir -p $logDir
    fi
    pg_ctl start -D $dataDir -l $logDir/serverlog
    if ! psql -lqt | cut -d \| -f 1 | grep -qw hive; then
        echo "Create user - hive"
        createuser -d hive
        echo "Create database - hive"
        createdb -U hive hive
    fi
}

function startHive() {
    echo "Make the HDFS directories before can create a table in Hive"
    hadoop fs -mkdir -p /tmp
    hadoop fs -mkdir -p /user/hive/warehouse
    hadoop fs -chmod g+w /tmp
    hadoop fs -chmod g+w /user/hive/warehouse
    echo "Try Schema upgrade"
    schematool -dbType postgres -upgradeSchema
    if [ ! "$?" = "0" ]; then
        echo "Try Schema initialization"
        schematool -dbType postgres -initSchema
    fi
    echo "Start Metastore Server"
    local metastoreLogDir=$HOME/Applications/var/log/hive/metastore
    mkdir -p $metastoreLogDir
    nohup hive --service metastore >$metastoreLogDir/hivemetastore.out 2>$metastoreLogDir/hivemetastore.err & \
        echo $! > /tmp/hivemetastore.pid
    echo "Start HiveServer2"
    local hiveserver2LogDir=$HOME/Applications/var/log/hive/hiveserver2
    mkdir -p $hiveserver2LogDir
    nohup hiveserver2 >$hiveserver2LogDir/hiveserver2.out 2>$hiveserver2LogDir/hiveserver2.err & \
        echo $! > /tmp/hiveserver2.pid
}

function startLivy() {
    echo "Start Livy"
    livy-server start
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

function startPresto() {
    echo "Start Presto"
    launcher start --launcher-log-file $APPLICATION_LOG_DIR/presto/launcher.log --server-log-file $APPLICATION_LOG_DIR/presto/server.log
}

DIR="${0%/*}"

source $DIR/environment.env

startHadoop
startAlluxio
startPostgresql
startHive
startLivy
startZooKeeper
startHBase
startPhoenix
startKafka
startPresto
