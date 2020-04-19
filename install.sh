#!/usr/bin/env sh

function get_downloaded_filename() {
    filename=$(basename $1)
    echo $DOWNLOAD_DIR/$filename
}

function download_binary() {
    download_filename=$(get_downloaded_filename $1)
    echo "Trying to download $1 to $download_filename"
    local file_exist=$([[ -e $download_filename ]] && echo 'true' || echo 'false')
    if [ "$file_exist" == "true" ]; then
        echo "File was downloaded in $download_filename"
        file_SHA=$(shasum -a 512 -b $download_filename | cut -d' ' -f1)
        if [ "$file_SHA" != "$2" ]; then
            echo "SHA checksum for $download_filename was invalid"
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

function extract_binary() {
    download_filename=$(get_downloaded_filename $1)
    echo "Trying to extract $download_filename to $2"
    if [ -d $2 ]; then
        echo "File was extracted in $2"
    else
        echo "Extracting to $2"
        mkdir -p $2
        tar -xvf $download_filename -C $2 --strip-components=1
    fi
    printf "\n"
}

DIR="${0%/*}"

source $DIR/binary.env
source $DIR/environment.env

set -e

mkdir -p $DOWNLOAD_DIR
mkdir -p $APPLICATION_DIR

declare -a services=(
    "$POSTGRESQL_URL|$POSTGRESQL_SHA|$POSTGRESQL_HOME"
    "$ZOOKEEPER_URL|$ZOOKEEPER_SHA|$ZOOKEEPER_HOME"
    "$HADOOP_URL|$HADOOP_SHA|$HADOOP_HOME"
    "$TEZ_URL|$TEZ_SHA|$TEZ_HOME"
    "$HIVE_URL|$HIVE_SHA|$HIVE_HOME"
    "$HBASE_URL|$HBASE_SHA|$HBASE_HOME"
    "$PHOENIX_URL|$PHOENIX_SHA|$PHOENIX_HOME"
    "$SPARK_URL|$SPARK_SHA|$SPARK_HOME"
    "$LIVY_URL|$LIVY_SHA|$LIVY_HOME"
    "$ALLUXIO_URL|$ALLUXIO_SHA|$ALLUXIO_HOME"
    "$KAFKA_URL|$KAFKA_SHA|$KAFKA_HOME"
    "$CASSANDRA_URL|$CASSANDRA_SHA|$CASSANDRA_HOME"
    "$PRESTO_URL|$PRESTO_SHA|$PRESTO_HOME"
)

for service in "${services[@]}"
do
    binary="$(cut -d'|' -f1 <<<"$service")"
    binary_sha="$(cut -d'|' -f2 <<<"$service")"
    binary_extract_dir="$(cut -d'|' -f3 <<<"$service")"
    download_binary $binary $binary_sha
    extract_binary $binary $binary_extract_dir
done

declare -a clients=(
    "$PRESTO_CLI_URL|$PRESTO_CLI_SHA"
)

for client in "${clients[@]}"
do
    binary="$(cut -d'|' -f1 <<<"$client")"
    binary_sha="$(cut -d'|' -f2 <<<"$client")"
    download_binary $binary $binary_sha
done
