#!/usr/bin/env sh

function checkBrew() {
    if ! type brew > /dev/null; then
        echo "You need to have the Homebrew installed: https://brew.sh"
        exit 10
    fi
}

function installOrUpgrade() {
    formula=$1
    if brew $2 ls --versions $formula > /dev/null; then
        echo "Trying to upgrade $1"
        brew $2 upgrade $formula
    else
        echo "Trying to install $1"
        brew $2 install $formula
    fi
}

function installOrUpgradeHadoop() {
    installOrUpgrade hadoop
    echo "Installing required softwares for hadoop"
    installOrUpgrade openssh
    installOrUpgrade pdsh
}

brew update

installOrUpgrade java8 cask
installOrUpgradeHadoop
installOrUpgrade hive
installOrUpgrade apache-spark
