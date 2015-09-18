# Import a graph from internet into GraphX

1. Download and decompress a compressed graph edge list file.  

  ```
  $ cd ~/
  $ wget https://storage.googleapis.com/graph-data/lab_data_lj.tar.gz
  $ tar -xzf lab_data_lj.tar.gz
  ```

2. Create a new directory in HDFS:  
  `$ $HADOOP_PREFIX/bin/hadoop fs -mkdir graph-data`
  
3. Put local graph files into HDFS:
  `$ $HADOOP_PREFIX/bin/hadoop fs -put lab_data_lj graph-data`
  * Make sure files are placed correctly with:
    `$ $HADOOP_PREFIX/bin/hadoop fs -ls graph-data/lab_data_lj`

4. Start Spark shell.
  `$ $SPARK_HOME/bin/spark-shell --master yarn-client`
  
5. Import graph files from HDFS:

  ```
  import org.apache.spark._
  import org.apache.spark.graphx._
  import org.apache.spark.rdd.RDD
  
  val graph = GraphLoader.edgeListFile(sc, "hdfs://test-01/user/yosub_shin_0/graph-data/lab_data_lj/xaa")
  ```
  
6. Now we can do following:

  ```
  scala> graph.vertices.count
  res1: Long = 1233069
  scala> graph.edges.count
  res2: Long = 4312111
  
