# PowerGraph Setup

0. Install prerequisite binaries

  ```
  sudo apt-get update
  sudo apt-get install -y gcc g++ cmake build-essential zlib1g zlib1g-dev libgomp1 openmpi-bin openmpi-doc libopenmpi-dev default-jdk
  ```

0. Download PowerGraph from its Git repository. 

  ```
  git clone https://github.com/dato-code/PowerGraph.git
  ```

0. Configure and build PowerGraph

  ```
  cd PowerGraph
  ./configure --no_mpi
  cd release/toolkits/graph_analytics
  make pagerank -j30
  ```

0. Set hostnames for rsync at `~/machines`

0. Create `release/toolkits/graph_analytics/rsync.sh` with:  

  ```
  cd ~/PowerGraph/release/toolkits
  ~/PowerGraph/scripts/mpirsync
  cd ~/PowerGraph/deps/local
  ~/PowerGraph/scripts/mpirsync
  cd ~/graphs
  ~/PowerGraph/scripts/mpirsync
  ```

0. Execute our program with:
  ```
  # mpiexec -n <number of hosts> -hostfile ~/machines <path to graph program> --graph=<graph file>
  mpiexec -n 2 -hostfile ~/machines ./pagerank --graph=/home/yosub_shin_0/graphs/livejournal/ --format=snap --iterations=10 --graph_opts="ingress=random"
  ```
  
# Other commands

* Copy files from Google Cloud Storage

  ```
  gsutil cp -r gs://graph-data/livejournal ~/graphs/
  ```

* Split graph files in n-ways
  
  ```
  split -n <number of splits> <input graph file>
  ```
  
  
