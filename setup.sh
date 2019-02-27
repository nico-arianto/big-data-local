#!/usr/bin/env sh

function enableRemoteLogin() {
    echo "Checking the Remote Login"
    if [ ! "$(sudo systemsetup -getremotelogin)" = "Remote Login: On" ]; then
        echo "Enabling Remote Login"
        sudo systemsetup -setremotelogin on
    fi
    printf "\n"
}

function setupPassphraselessSSH() {
    echo "Checking the Passphrase SSH"
    if [ ! -e ~/.ssh/id_rsa ]; then
        echo "Generating the new SSH key"
        ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
        cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
        chmod 0600 ~/.ssh/authorized_keys
    fi
    printf "\n"
}

function overrideConfiguration() {
    local targetFile="$3/$1"
    local backupFile="$3/$1.backup"
    local sourceFile="$2/$1"
    if [ ! -e $targetFile ]; then
        echo "Creates an empty $backupFile"
        touch $backupFile
    fi
    if [ ! -e $backupFile ]; then
        echo "Backup the $targetFile to $backupFile"
        cp $targetFile $backupFile
    fi
    echo "Override the $targetFile"
    cp $sourceFile $targetFile
    sed -i "" 's|{{APPLICATION_DATA_DIR}}|'"$APPLICATION_DATA_DIR"'|g' $targetFile
    sed -i "" 's|{{APPLICATION_LOG_DIR}}|'"$APPLICATION_LOG_DIR"'|g' $targetFile
    sed -i "" 's|{{JAVA_HOME}}|'"$JAVA_HOME"'|g' $targetFile
    sed -i "" 's|{{HADOOP_HOME}}|'"$HADOOP_HOME"'|g' $targetFile
    sed -i "" 's|{{HADOOP_CONF_DIR}}|'"$HADOOP_CONF_DIR"'|g' $targetFile
    sed -i "" 's|{{TEZ_VERSION}}|'"$TEZ_VERSION"'|g' $targetFile
    sed -i "" 's|{{TEZ_CONF_DIR}}|'"$TEZ_CONF_DIR"'|g' $targetFile
    sed -i "" 's|{{TEZ_JARS}}|'"$TEZ_JARS"'|g' $targetFile
    sed -i "" 's|{{HIVE_HOME}}|'"$HIVE_HOME"'|g' $targetFile
    sed -i "" 's|{{HIVE_VERSION}}|'"$HIVE_VERSION"'|g' $targetFile
    sed -i "" 's|{{ALLUXIO_CLIENT_JAR}}|'"$ALLUXIO_CLIENT_JAR"'|g' $targetFile
    sed -i "" 's|{{PHOENIX_SERVER_JAR}}|'"$PHOENIX_SERVER_JAR"'|g' $targetFile
    sed -i "" 's|{{PHOENIX_CLIENT_JAR}}|'"$PHOENIX_CLIENT_JAR"'|g' $targetFile
}

function copyConfiguration() {
    local sourceDir="$DIR/$1"
    local targetDir=$2
    mkdir -p $targetDir
    for config in $sourceDir/*; do
        if [ -f $config ]; then
            overrideConfiguration $(basename $config) $sourceDir $targetDir
        fi
    done
}

function configureHadoop() {
    echo "Configuring Hadoop"
    copyConfiguration hadoop $HADOOP_CONF_DIR
    printf "\n"
}

function configureTez() {
    echo "Configuring Tez"
    copyConfiguration tez $TEZ_CONF_DIR
    printf "\n"
}

function configureHive() {
    echo "Configuring Hive"
    copyConfiguration hive $HIVE_CONF_DIR
    printf "\n"
}

function configureSpark() {
    echo "Configuring Spark"
    overrideConfiguration hive-site.xml $HIVE_CONF_DIR $SPARK_CONF_DIR
    copyConfiguration spark $SPARK_CONF_DIR
    printf "\n"
}

function configureLivy() {
    echo "Configuring Livy"
    copyConfiguration livy $LIVY_HOME/conf
    printf "\n"
}

function configureAlluxio() {
    echo "Configuring Alluxio"
    copyConfiguration alluxio $ALLUXIO_HOME/conf
    printf "\n"
}

function configureZooKeeper() {
    echo "Configuring ZooKeeper"
    copyConfiguration zookeeper $ZOOKEEPER_HOME/conf
    printf "\n"
}

function configureHBase() {
    echo "Configuring HBase"
    copyConfiguration hbase $HBASE_CONF_DIR
    printf "\n"
}

function configureKafka() {
    echo "Configuring Kafka"
    copyConfiguration kafka $KAFKA_HOME/config
    printf "\n"
}

function configurePresto() {
    echo "Configuring Presto"
    copyConfiguration presto $PRESTO_HOME/etc
    copyConfiguration presto/catalog $PRESTO_HOME/etc/catalog
    printf "\n"
    local targetCLI=$PRESTO_HOME/bin/presto
    if [ ! -e $targetCLI ]; then
        echo "Configuring Presto CLI"
        local sourceCLI=$DOWNLOAD_DIR/presto-cli-$PRESTO_VERSION-executable.jar 
        cp $sourceCLI $targetCLI
        echo "Copy the $sourceCLI to $targetCLI"
        chmod +x $targetCLI
        printf "\n"
    fi
}

function replaceHadoopLib() {
    local hadoopLib=$1
    local libDir=$2
    local libBackupDir=$3
    if [ -e $hadoopLib ]; then
        if [ "$libBackupDir" != "" ]; then
            echo "Backup the $hadoopLib to $libBackupDir"
            mv $hadoopLib $libBackupDir
        else
            echo "Remove the $hadoopLib"
            rm $hadoopLib
        fi
    fi
    local hadoopLibName=$(basename $hadoopLib | sed 's/[0-9]/\[0-9\]/g')
    local newHadoopLib=$(find $HADOOP_HOME -name "$hadoopLibName" | head -n 1)
    if [ "$newHadoopLib" != "" ]; then
        echo "Replace with $newHadoopLib"
        cp $newHadoopLib $libDir
    fi
}

function replaceHadoopLibraries() {
    local libDir=$1
    local libBackupDir=$2
    for hadoopLib in $(find $libDir -name "hadoop-*.jar"); do
        replaceHadoopLib $hadoopLib $libDir $libBackupDir
    done
}

function replaceHBaseHadoop() {
    local libDir=$HBASE_HOME/lib
    local libBackupDir=$HBASE_HOME/lib/hadoop-backup
    if [ ! -d $libBackupDir ]; then
        mkdir -p $libBackupDir
        replaceHadoopLibraries $libDir $libBackupDir
    fi
    printf "\n"
}

function replaceTezHadoop() {
    local libDir=$TEZ_JARS/lib
    local libBackupDir=$TEZ_JARS/lib/hadoop-backup
    if [ ! -d $libBackupDir ]; then
        mkdir -p $libBackupDir
        replaceHadoopLibraries $libDir $libBackupDir
        printf "\n"
    fi
    local binFilename=tez.tar.gz
    local binPath=$TEZ_JARS/share
    local binFile=$binPath/$binFilename
    local binBackupFile=$binPath/$binFilename.backup
    if [ ! -e $binBackupFile ]; then
        local binDir=$binPath/tez
        local binLibDir=$binDir/lib
        echo "Backup the $binFile to $binBackupFile"
        mv $binFile $binBackupFile
        mkdir -p $binDir
        echo "Extract the $binBackupFile to $binDir"
        tar -zxvf $binBackupFile -C $binDir
        replaceHadoopLibraries $binLibDir
        replaceHadoopLib "jetty-sslengine-*.jar" $binLibDir
        echo "Create the $binFile"
        cd $binDir && tar -zcvf $binFilename * && mv $binFilename $binPath && cd -
        rm -rf $binDir
        printf "\n"
    fi
}

DIR="${0%/*}"

source $DIR/environment.env

ALLUXIO_CLIENT_JAR=$ALLUXIO_HOME/client/alluxio-$ALLUXIO_VERSION-client.jar
PHOENIX_SERVER_JAR=$PHOENIX_HOME/phoenix-$PHOENIX_VERSION-HBase-$PHOENIX_HBASE_VERSION-server.jar
PHOENIX_CLIENT_JAR=$PHOENIX_HOME/phoenix-$PHOENIX_VERSION-HBase-$PHOENIX_HBASE_VERSION-client.jar

enableRemoteLogin
setupPassphraselessSSH
configureHadoop
configureTez
configureHive
configureSpark
configureLivy
configureAlluxio
configureZooKeeper
configureHBase
configureKafka
configurePresto
replaceHBaseHadoop
replaceTezHadoop
