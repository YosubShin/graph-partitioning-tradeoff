#!/bin/bash

TIME=`date +%Y-%m-%d.%H:%M:%S`
export OUTPUT_CSV_PATH=/home/yosub_shin_0/graph-partitioning-tradeoff-${TIME}.csv
export GRAPH_FILE_PATH=hdfs://test-01/user/yosub_shin_0/graph-data/lab_data_lj

~/spark-1.5.0-bin-hadoop2.6/bin/spark-submit \
--class GraphPartitioningTradeoff \
--master spark://test-01:7077 \
~/spark-program/target/scala-2.10/graph-partitioning-tradeoff_2.10-0.1-SNAPSHOT.jar
