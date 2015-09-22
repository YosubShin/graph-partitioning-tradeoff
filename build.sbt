name := "graph-partitioning-tradeoff"

scalaVersion := "2.10.4"

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core"    % "1.5.0",
  "org.apache.spark" %% "spark-graphx"  % "1.5.0",
  "net.sf.opencsv" % "opencsv" % "2.3")

resolvers += Resolver.sonatypeRepo("snapshots")