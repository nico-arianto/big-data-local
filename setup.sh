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
    HADOOP_CONFIG=$HADOOP_HOME/etc/hadoop/
    if [ ! -e $HADOOP_CONFIG/core-site.xml.backup ]; then
        echo "Backup the core-site.xml to core-site.xml.backup"
        cp $HADOOP_CONFIG/core-site.xml $HADOOP_CONFIG/core-site.xml.backup
    fi
    if [ ! -e $HADOOP_CONFIG/hdfs-site.xml.backup ]; then
        echo "Backup the hdfs-site.xml to hdfs-site.xml.backup"
        cp $HADOOP_CONFIG/hdfs-site.xml $HADOOP_CONFIG/hdfs-site.xml.backup
    fi
    if [ ! -e $HADOOP_CONFIG/mapred-site.xml.backup ]; then
        echo "Backup the mapred-site.xml to mapred-site.xml.backup"
        cp $HADOOP_CONFIG/mapred-site.xml $HADOOP_CONFIG/mapred-site.xml.backup
    fi
    if [ ! -e $HADOOP_CONFIG/yarn-site.xml.backup ]; then
        echo "Backup the yarn-site.xml to yarn-site.xml.backup"
        cp $HADOOP_CONFIG/yarn-site.xml $HADOOP_CONFIG/yarn-site.xml.backup
    fi
    echo "Override the core-site.xml"
    cp $DIR/hadoop/core-site.xml $HADOOP_CONFIG/core-site.xml
    echo "Override the hdfs-site.xml"
    cp $DIR/hadoop/hdfs-site.xml $HADOOP_CONFIG/hdfs-site.xml
    echo "Override the mapred-site.xml"
    cp $DIR/hadoop/mapred-site.xml $HADOOP_CONFIG/mapred-site.xml
    echo "Override the yarn-site.xml"
    cp $DIR/hadoop/yarn-site.xml $HADOOP_CONFIG/yarn-site.xml
}

DIR="${0%/*}"

source $DIR/environment.sh

enableRemoteLogin
setupPassphraselessSSH
configureHadoop
