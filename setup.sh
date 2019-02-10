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
    sed -i "" 's|{{HOME}}|'"$HOME"'|g' $targetFile
    sed -i "" 's|{{JAVA_HOME}}|'"$JAVA_HOME"'|g' $targetFile
    sed -i "" 's|{{HADOOP_HOME}}|'"$HADOOP_HOME"'|g' $targetFile
    sed -i "" 's|{{HADOOP_CONF_DIR}}|'"$HADOOP_CONF_DIR"'|g' $targetFile
    sed -i "" 's|{{HIVE_HOME}}|'"$HIVE_HOME"'|g' $targetFile
    sed -i "" 's|{{HIVE_VERSION}}|'"$HIVE_VERSION"'|g' $targetFile
    sed -i "" 's|{{DERBY_CLIENT_JAR}}|'"$DERBY_CLIENT_JAR"'|g' $targetFile
    sed -i "" 's|{{ALLUXIO_CLIENT_JAR}}|'"$ALLUXIO_CLIENT_JAR"'|g' $targetFile
    sed -i "" 's|{{PHOENIX_SERVER_JAR}}|'"$PHOENIX_SERVER_JAR"'|g' $targetFile
    sed -i "" 's|{{PHOENIX_CLIENT_JAR}}|'"$PHOENIX_CLIENT_JAR"'|g' $targetFile
}

function configureHadoop() {
    echo "Configuring Hadoop"
    local sourceDir="$DIR/hadoop"
    for config in $sourceDir/*; do
        overrideConfiguration $(basename $config) $sourceDir $HADOOP_CONF_DIR
    done
    printf "\n"
}

function configureHive() {
    echo "Configuring Hive"
    local sourceDir="$DIR/hive"
    for config in $sourceDir/*; do
        overrideConfiguration $(basename $config) $sourceDir $HIVE_CONF_DIR
    done
    printf "\n"
}

function configureSpark() {
    echo "Configuring Spark"
    overrideConfiguration hive-site.xml $HIVE_CONF_DIR $SPARK_CONF_DIR
    local sourceDir="$DIR/spark"
    for config in $sourceDir/*; do
        overrideConfiguration $(basename $config) $sourceDir $SPARK_CONF_DIR
    done
    printf "\n"
}

function configureAlluxio() {
    echo "Configuring Alluxio"
    local sourceDir="$DIR/alluxio"
    for config in $sourceDir/*; do
        overrideConfiguration $(basename $config) $sourceDir $ALLUXIO_HOME/conf
    done
    printf "\n"
}

function configureZooKeeper() {
    echo "Configuring ZooKeeper"
    local sourceDir="$DIR/zookeeper"
    for config in $sourceDir/*; do
        overrideConfiguration $(basename $config) $sourceDir $ZOOKEEPER_HOME/conf
    done
    printf "\n"
}

function configureHBase() {
    echo "Configuring HBase"
    local sourceDir="$DIR/hbase"
    for config in $sourceDir/*; do
        overrideConfiguration $(basename $config) $sourceDir $HBASE_CONF_DIR
    done
    printf "\n"
}

DIR="${0%/*}"

source $DIR/environment.env

enableRemoteLogin
setupPassphraselessSSH
configureHadoop
configureHive
configureSpark
configureAlluxio
configureZooKeeper
configureHBase
