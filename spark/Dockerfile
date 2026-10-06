# Base image: Python 3.10 on Debian Bookworm
FROM python:3.10-bookworm as spark-base

# Spark version
ARG SPARK_VERSION=3.5.9

# Install OS-level dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo \
    curl \
    vim \
    unzip \
    rsync \
    openjdk-17-jdk \
    build-essential \
    ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Java
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Spark and Hadoop paths
ENV SPARK_HOME=/opt/spark
ENV HADOOP_HOME=/opt/hadoop

# Create directories
RUN mkdir -p ${HADOOP_HOME} && \
    mkdir -p ${SPARK_HOME}

WORKDIR ${SPARK_HOME}

# Download and install Spark
RUN curl https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz \
    -o spark-${SPARK_VERSION}-bin-hadoop3.tgz \
    && tar xvzf spark-${SPARK_VERSION}-bin-hadoop3.tgz \
       --directory /opt/spark \
       --strip-components 1 \
    && rm -f spark-${SPARK_VERSION}-bin-hadoop3.tgz

# Python dependencies
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Spark binaries
ENV PATH="/opt/spark/sbin:/opt/spark/bin:${PATH}"

# Spark Master
ENV SPARK_MASTER="spark://spark-master:7077"
ENV SPARK_MASTER_HOST=spark-master
ENV SPARK_MASTER_PORT=7077

# Python used by PySpark
ENV PYSPARK_PYTHON=python3

# Spark configuration
COPY conf/spark-defaults.conf "$SPARK_HOME/conf"

# Make Spark scripts executable
RUN chmod u+x /opt/spark/sbin/* && \
    chmod u+x /opt/spark/bin/*

# PySpark Python libraries
ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH

# Entrypoint
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]