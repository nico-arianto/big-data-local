#!/usr/bin/env sh

function enableRemoteLogin() {
    echo "Checking the Remote Login"
    if [ ! "$(sudo systemsetup -getremotelogin)" = "Remote Login: On" ]; then
        echo "Enabling Remote Login"
        sudo systemsetup -setremotelogin on
    fi
}

function setupPassphraselessSSH() {
    echo "Checking the Passphrase SSH"
    if [ ! -e ~/.ssh/id_rsa ]; then
        echo "Generating the new SSH key"
        ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
        cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
        chmod 0600 ~/.ssh/authorized_keys
    fi
}

function configureHadoop() {
    if [ ! -e $HADOOP_CONF_DIR/hadoop-env.sh.backup ]; then
        echo "Backup the hadoop-env.sh to hadoop-env.sh.backup"
        cp $HADOOP_CONF_DIR/hadoop-env.sh $HADOOP_CONF_DIR/hadoop-env.sh.backup
    fi
    if [ ! -e $HADOOP_CONF_DIR/core-site.xml.backup ]; then
        echo "Backup the core-site.xml to core-site.xml.backup"
        cp $HADOOP_CONF_DIR/core-site.xml $HADOOP_CONF_DIR/core-site.xml.backup
    fi
    if [ ! -e $HADOOP_CONF_DIR/hdfs-site.xml.backup ]; then
        echo "Backup the hdfs-site.xml to hdfs-site.xml.backup"
        cp $HADOOP_CONF_DIR/hdfs-site.xml $HADOOP_CONF_DIR/hdfs-site.xml.backup
    fi
    if [ ! -e $HADOOP_CONF_DIR/mapred-site.xml.backup ]; then
        echo "Backup the mapred-site.xml to mapred-site.xml.backup"
        cp $HADOOP_CONF_DIR/mapred-site.xml $HADOOP_CONF_DIR/mapred-site.xml.backup
    fi
    if [ ! -e $HADOOP_CONF_DIR/yarn-site.xml.backup ]; then
        echo "Backup the yarn-site.xml to yarn-site.xml.backup"
        cp $HADOOP_CONF_DIR/yarn-site.xml $HADOOP_CONF_DIR/yarn-site.xml.backup
    fi
    echo "Override the hadoop-env.sh"
    sed -i '.backup' -e 's|# export JAVA_HOME=|export JAVA_HOME='"$JAVA_HOME"'|g' $DIR/hadoop/hadoop-env.sh
    cp $DIR/hadoop/hadoop-env.sh $HADOOP_CONF_DIR/hadoop-env.sh
    rm $DIR/hadoop/hadoop-env.sh
    mv $DIR/hadoop/hadoop-env.sh.backup $DIR/hadoop/hadoop-env.sh
    echo "Override the core-site.xml"
    cp $DIR/hadoop/core-site.xml $HADOOP_CONF_DIR/core-site.xml
    echo "Override the hdfs-site.xml"
    cp $DIR/hadoop/hdfs-site.xml $HADOOP_CONF_DIR/hdfs-site.xml
    echo "Override the mapred-site.xml"
    cp $DIR/hadoop/mapred-site.xml $HADOOP_CONF_DIR/mapred-site.xml
    echo "Override the yarn-site.xml"
    cp $DIR/hadoop/yarn-site.xml $HADOOP_CONF_DIR/yarn-site.xml
}

function configureHive() {
    echo "Override the hive-env.sh"
    cp $DIR/hive/hive-env.sh $HIVE_CONF_DIR/hive-env.sh
    echo "Override the hive-site.xml"
    cp $DIR/hive/hive-site.xml $HIVE_CONF_DIR/hive-site.xml
}

DIR="${0%/*}"

source $DIR/environment.sh

enableRemoteLogin
setupPassphraselessSSH
configureHadoop
configureHive
