# Import a graph from internet into GraphX

1. From a place where the original graph file exists, upload graph file to Google Cloud Storage:   
  `$ gsutil cp lab_data_lj gs://graph-data/`
  * Check that the file is uploaded on Google Cloud Storage bucket correctly:   
    `$ gsutil ls gs://graph-data/`

2. Download the graph edge list file.  
  `$ gsutil cp gs://graph-data/lab_data_lj ~/`

3. Create a new directory in HDFS:  
  `$ $HADOOP_PREFIX/bin/hadoop fs -mkdir graph-data`
  
4. Put local graph files into HDFS:
  `$ $HADOOP_PREFIX/bin/hadoop fs -put lab_data_lj graph-data`
  * Make sure files are placed correctly with:
    `$ $HADOOP_PREFIX/bin/hadoop fs -ls graph-data/lab_data_lj`

5. Start Spark shell.
  `$ $SPARK_HOME/bin/spark-shell --master yarn-client`
  
6. Import graph files from HDFS:

  ```
  import org.apache.spark._
  import org.apache.spark.graphx._
  import org.apache.spark.rdd.RDD
  
  val graph = GraphLoader.edgeListFile(sc, "hdfs://test-01/user/yosub_shin_0/graph-data/lab_data_lj")
  ```
  
7. Now we can do following:

  ```
  scala> graph.vertices.count
  res1: Long = 1233069
  scala> graph.edges.count
  res2: Long = 4312111
  ```
  
# Install SBT and Run Spark thorugh `spark-submit`

1. Install sbt (http://www.scala-sbt.org/0.13/tutorial/Installing-sbt-on-Linux.html)  
  
  ```
  echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
  sudo apt-get update
  sudo apt-get install sbt
  ```

