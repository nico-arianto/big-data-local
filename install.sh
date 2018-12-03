#!/usr/bin/env sh

function checkBrew() {
    if ! type brew > /dev/null; then
        echo "You need to have the Homebrew installed: https://brew.sh"
        exit 10
    fi
}

function installOrUpgrade() {
    formula=$1
    if brew ls --versions $formula > /dev/null; then
        echo "Trying to upgrade $1"
        brew upgrade $formula
    else
        echo "Trying to install $1"
        brew install $formula
    fi    
}

function installOrUpgradeHadoop() {
    installOrUpgrade hadoop
    echo "Installing required softwares for hadoop"
    installOrUpgrade openssh
    installOrUpgrade pdsh
}

brew update

installOrUpgradeHadoop
installOrUpgrade hive
installOrUpgrade apache-spark
