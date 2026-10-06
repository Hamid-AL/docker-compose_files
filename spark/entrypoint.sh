#!/bin/bash
# Use bash as the shell for this script

# First argument passed to the container determines its role
# Examples:
#   master  -> Spark Master node
#   worker  -> Spark Worker node
#   history -> Spark History Server
SPARK_WORKLOAD=$1

# Log which role this container is starting as
echo "SPARK_WORKLOAD: $SPARK_WORKLOAD"

# If this container is started as a Spark Master
if [ "$SPARK_WORKLOAD" == "master" ];
then
  # Start the Spark Master process
  # - Listens for workers and job submissions on port 7077
  start-master.sh -p 7077

# If this container is started as a Spark Worker
elif [ "$SPARK_WORKLOAD" == "worker" ];
then
  # Start a Spark Worker and connect it to the Master
  # "spark-master" is resolved via Docker's internal DNS
  # Each worker is configured with 2 CPU cores and 2 GB of memory
  start-worker.sh \
    --cores 2 \
    --memory 2G \
    spark://spark-master:7077

# If this container is started as the History Server
elif [ "$SPARK_WORKLOAD" == "history" ]
then
  # Start Spark History Server
  # - Reads completed job event logs
  # - Serves UI on port 18080
  start-history-server.sh
fi