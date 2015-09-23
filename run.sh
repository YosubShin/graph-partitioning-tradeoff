#!/bin/bash

TIME=`date +%Y-%m-%d.%H:%M:%S`
HOSTNAME=$(curl http://metadata/computeMetadata/v1/instance/hostname -H "Metadata-Flavor: Google")
export OUTPUT_CSV_PATH=/home/yosub_shin_0/graph-partitioning-tradeoff-${TIME}.csv
export GRAPH_FILE_PATH=hdfs://${HOSTNAME}/graph-data/lab_data_lj

~/spark-1.5.0-bin-hadoop2.6/bin/spark-submit \
--class GraphPartitioningTradeoff \
--master spark://${HOSTNAME}:7077 \
target/scala-2.10/graph-partitioning-tradeoff_2.10-0.1-SNAPSHOT.jar
