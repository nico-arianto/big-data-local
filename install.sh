#!/usr/bin/env sh

function get_filename() {
    echo "${1##*/}"
}

function get_downloaded_filename() {
    filename=$(get_filename $1)
    echo $DOWNLOAD_DIR/$filename
}

function download_binary() {
    echo "Trying to download $1"
    download_filename=$(get_downloaded_filename $1)
    local file_exist=$([[ -e $download_filename ]] && echo 'true' || echo 'false')
    if [ "$file_exist" == "true" ]; then
        echo "File was downloaded in $download_filename"
        file_md5=$(md5 -q $download_filename)
        if [ "$file_md5" != "$2" ]; then
            echo "MD5 checksum for $download_filename was invalid"
            rm $download_filename
            file_exist='false'
        fi
    fi
    if [ "$file_exist" == "false" ]; then
        echo "Downloading to $download_filename"
        curl -R $1 -o $download_filename
    fi
    printf "\n"
}

function get_foldername() {
    echo "${1%%/*}"
}

function extract_binary() {
    echo "Trying to extract $1"
    download_filename=$(get_downloaded_filename $1)
    head_item=$(tar -tf $download_filename | head -n 1)
    extract_foldername=$(get_foldername $head_item)
    extract_dirname=$APPLICATION_DIR/$extract_foldername
    if [ -d $extract_dirname ]; then
        echo "File was extracted in $extract_dirname"
    else
        echo "Extracting to $extract_dirname"
        if [[ $download_filename =~ \.t?gz$ ]]; then
            tar -xvf $download_filename -C $APPLICATION_DIR
        elif [[ $download_filename =~ \.zip$ ]]; then
            unzip $download_filename -d $APPLICATION_DIR
        else
            echo "Failed to extract because of unsupported filetype"
        fi
    fi
    printf "\n"
}

DIR="${0%/*}"

source $DIR/version.info
source $DIR/binary.info
source $DIR/directory.info

declare -a packages=(
    "$HADOOP_BINARY|$HADOOP_MD5"
    "$TEZ_BINARY|$TEZ_MD5"
    "$ALLUXIO_BINARY|$ALLUXIO_MD5"
    "$POSTGRESQL_BINARY|$POSTGRESQL_MD5"
    "$HIVE_BINARY|$HIVE_MD5"
    "$SPARK_BINARY|$SPARK_MD5"
    "$LIVY_BINARY|$LIVY_MD5"
    "$ZOOKEEPER_BINARY|$ZOOKEEPER_MD5"
    "$HBASE_BINARY|$HBASE_MD5"
    "$PHOENIX_BINARY|$PHOENIX_MD5"
    "$KAFKA_BINARY|$KAFKA_MD5"
    "$PRESTO_BINARY|$PRESTO_MD5"
    "$CASSANDRA_BINARY|$CASSANDRA_MD5"
)

mkdir -p $DOWNLOAD_DIR
mkdir -p $APPLICATION_DIR

for package in "${packages[@]}"
do
    binary="${package%%|*}"
    binary_checksum="${package##*|}"
    download_binary $binary $binary_checksum
    extract_binary $binary
done

download_binary $PRESTO_CLI_BINARY $PRESTO_CLI_MD5
