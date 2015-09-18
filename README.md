# Spark 1.5.0 & GraphX & Hadoop 2.7.1 install

1. Create VM with 2 CPU & 8GB memory with debian 7 wheezy.
2. (Optional) Install prerequisite binaries:
  * Install Emacs  
      `$ sudo apt-get install emacs`
  * Install Byobu  
      `$ sudo apt-get install byobu`
      * Attach to byobu session: `$ byobu`
2. Install Java 7 (OpenJDK is fine.):
  `$ sudo apt-get install openjdk-7-jre`
3. Export `JAVA_HOME` to environment. Append following in `~/.bashrc` file:  
  `$ export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/jre` 
  * Apply the contents of `~/.bashrc` by doing following: `$ source ~/.bashrc`.
4. Download Hadoop 2.7.1 and install.

  ```
  $ wget http://mirrors.gigenet.com/apache/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz  
  $ tar -xzf hadoop-2.7.1.tar.gz
  $ cd hadoop-2.7.1
  ```
  * Export environment variables by appending `~/.bashrc`:   
  
      ```bash
      export HADOOP_PREFIX="/home/yosub_shin_0/hadoop-2.7.1"
      export HADOOP_HOME=$HADOOP_PREFIX
      export HADOOP_COMMON_HOME=$HADOOP_PREFIX
      export HADOOP_CONF_DIR=$HADOOP_PREFIX/etc/hadoop
      export HADOOP_HDFS_HOME=$HADOOP_PREFIX
      export HADOOP_MAPRED_HOME=$HADOOP_PREFIX
      export HADOOP_YARN_HOME=$HADOOP_PREFIX
      ```   
      * Make sure to replace `/home/yosub_shin_0` to directory in which Hadoop is installed at.
      * Apply the contents of `~/.bashrc` by doing following: `$ source ~/.bashrc`.
  * Test Hadoop on Standalone mode.
  
      ```
      $ mkdir input
      $ cp etc/hadoop/*.xml input
      $ bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.1.jar grep input output 'dfs[a-z.]+'
      $ cat output/*
      ```
      * You will see an ouput that looks like:  
      `1       dfsadmin`
      
5. Configure HDFS. (http://www.alexjf.net/blog/distributed-systems/hadoop-yarn-installation-definitive-guide/)
    * Edit `etc/hadoop/hdfs-site.xml` file to have following:
    
        ```
        <configuration>
            <property>
                <name>dfs.datanode.data.dir</name>
                <value>file:///home/yosub_shin_0/hadoop-2.7.1/hdfs/datanode</value>
                <description>Comma separated list of paths on the local filesystem of a DataNode where it should store its blocks.</description>
            </property>
        
            <property>
                <name>dfs.namenode.name.dir</name>
                <value>file:///home/yosub_shin_0/hadoop-2.7.1/hdfs/namenode</value>
                <description>Path on the local filesystem where the NameNode stores the namespace and transaction logs persistently.</description>
            </property>
        </configuration>
        ```
        * Make sure to edit `/home/yosub_shin_0` to where Hadoop is installed.
    * Also, add following to `etc/hadoop/core-site.xml`:
    
        ```
        <configuration>
            <property>
                <name>fs.defaultFS</name>
                <value>hdfs://localhost/</value>
                <description>NameNode URI</description>
            </property>
        </configuration>
        ```
        * For deploying a cluster with more than just a single machine, make sure to look at 'Cluster Installation' section and follow the direction there.
        
6. Configure YARN.
    * Update `etc/hadoop/yarn-site.xml` as following:
    
        ```
        <configuration>
            <property>
                <name>yarn.scheduler.minimum-allocation-mb</name>
                <value>128</value>
                <description>Minimum limit of memory to allocate to each container request at the Resource Manager.</description>
            </property>
            <property>
                <name>yarn.scheduler.maximum-allocation-mb</name>
                <value>2048</value>
                <description>Maximum limit of memory to allocate to each container request at the Resource Manager.</description>
            </property>
            <property>
                <name>yarn.scheduler.minimum-allocation-vcores</name>
                <value>1</value>
                <description>The minimum allocation for every container request at the RM, in terms of virtual CPU cores. Requests lower than this won't take effect, and the specified value will get allocated the minimum.</description>
            </property>
            <property>
                <name>yarn.scheduler.maximum-allocation-vcores</name>
                <value>2</value>
                <description>The maximum allocation for every container request at the RM, in terms of virtual CPU cores. Requests higher than this won't take effect, and will get capped to this value.</description>
            </property>
            <property>
                <name>yarn.nodemanager.resource.memory-mb</name>
                <value>6144</value>
                <description>Physical memory, in MB, to be made available to running containers</description>
            </property>
            <property>
                <name>yarn.nodemanager.resource.cpu-vcores</name>
                <value>2</value>
                <description>Number of CPU cores that can be allocated for containers.</description>
            </property>
        </configuration>
        ```
        * For deploying a cluster with more than just a single machine, make sure to look at 'Cluster Installation' section and follow the direction there.
        
7. Start everything with following script:

    ```
    ## Start HDFS daemons
    # Format the namenode directory (DO THIS ONLY ONCE, THE FIRST TIME)
    bin/hdfs namenode -format
    # Start the namenode daemon
    sbin/hadoop-daemon.sh start namenode
    # Start the datanode daemon
    sbin/hadoop-daemon.sh start datanode
    
    ## Start YARN daemons
    # Start the resourcemanager daemon
    sbin/yarn-daemon.sh start resourcemanager
    # Start the nodemanager daemon
    sbin/yarn-daemon.sh start nodemanager
    ```
    * Use `ps aux | grep java` to make sure all daemons are up and running.
    
8. Test Hadoop with:  
  `$ bin/hadoop jar share/hadoop/yarn/hadoop-yarn-applications-distributedshell-2.7.1.jar org.apache.hadoop.yarn.applications.distributedshell.Client --jar share/hadoop/yarn/hadoop-yarn-applications-distributedshell-2.7.1.jar --shell_command date --num_containers 2 --master_memory 1024`
    * Run following command `$ grep "" logs/userlogs/application_1442404936521_0001/**/stdout`.
    * This will result in each container giving us system time at each line:
    
        ```
        logs/userlogs/application_1442404936521_0001/container_1442404936521_0001_01_000002/stdout:Wed Sep 16 17:35:47 UTC 2015
        logs/userlogs/application_1442404936521_0001/container_1442404936521_0001_01_000003/stdout:Wed Sep 16 17:35:48 UTC 2015

9. Cluster Installation  
For cluster set up, we do the same thing, but we set up ResourceManager and NameNode only on one machine, whereas DataNode and NodeManager should run on all of the machines.
    * HDFS Configuration: Change `etc/hadoop/core-site.xml`
    
        ```
        <configuration>
            <property>
                <name>fs.defaultFS</name>
                <value>hdfs://test-01/</value>
                <description>NameNode URI</description>
            </property>
        </configuration>
        ```
    * YARN Configuration: Change `etc/hadoop/yarn-site.xml`

        ```
        <configuration>
            <property>
                <name>yarn.resourcemanager.hostname</name>
                <value>test-01</value>
                <description>The hostname of the RM.</description>
            </property>
        </configuration>
        ```

10. Download Spark 1.5.0 and install (Choose 'Pre-built for Hadoop 2.6 and later' option).
 
 ```
 $ cd ~/
 $ wget http://apache.mirrors.ionfish.org/spark/spark-1.5.0/spark-1.5.0-bin-hadoop2.6.tgz
 $ tar -xzf spark-1.5.0-bin-hadoop2.6.tgz
 $ cd spark-1.5.0-bin-hadoop2.6
 $ cp conf/spark-env.sh.template conf/spark-env.sh
 ```

 * Update `$ emacs conf/spark-env.sh` by appending:  
 `export SPARK_DIST_CLASSPATH=$(/path/to/hadoop/bin/hadoop classpath)`
  * Note that you should change `/path/to/hadoop/` to your home directory path followed by `hadoop-2.7.1`.

11. Try to run a sample job using YARN cluster mode.  
 ```
 ./bin/spark-submit --class org.apache.spark.examples.SparkPi \
    --master yarn-cluster \
    --num-executors 2 \
    --driver-memory 1g \
    --executor-memory 1g \
    --executor-cores 1 \
    lib/spark-examples*.jar \
    10
 ```
12. Or run an interactive shell as following:  
 ```
 $ ./bin/spark-shell --master yarn-client
 ```
        
        
