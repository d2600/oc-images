FROM flink:1.19.0-scala_2.12

LABEL maintainer="damian.ruiz"
LABEL description="Flink 1.19 con conectores Redis y S3"
LABEL version="redis-lab3"

ENV FLINK_HOME=/opt/flink
ENV FLINK_LIB_DIR=${FLINK_HOME}/lib
ARG REDIS_CONNECTOR_VERSION=1.1.0
ARG SCALA_VERSION=2.12
ARG FLINK_VERSION=1.19.0

# ---------------------------------------------------------
# Redis connector (Bahir)
# ---------------------------------------------------------
RUN wget -q https://repo1.maven.org/maven2/org/apache/bahir/flink-connector-redis_${SCALA_VERSION}/${REDIS_CONNECTOR_VERSION}/flink-connector-redis_${SCALA_VERSION}-${REDIS_CONNECTOR_VERSION}.jar \
    -O ${FLINK_LIB_DIR}/flink-connector-redis_${SCALA_VERSION}-${REDIS_CONNECTOR_VERSION}.jar

# ---------------------------------------------------------
# S3 filesystem connectors (Hadoop + Presto)
# ---------------------------------------------------------
RUN wget -q https://repo1.maven.org/maven2/org/apache/flink/flink-s3-fs-hadoop/${FLINK_VERSION}/flink-s3-fs-hadoop-${FLINK_VERSION}.jar \
    -O ${FLINK_LIB_DIR}/flink-s3-fs-hadoop-${FLINK_VERSION}.jar && \
    wget -q https://repo1.maven.org/maven2/org/apache/flink/flink-s3-fs-presto/${FLINK_VERSION}/flink-s3-fs-presto-${FLINK_VERSION}.jar \
    -O ${FLINK_LIB_DIR}/flink-s3-fs-presto-${FLINK_VERSION}.jar

# ---------------------------------------------------------
# Validación del contenido
# ---------------------------------------------------------
RUN ls -lh ${FLINK_LIB_DIR}/flink-connector-redis_${SCALA_VERSION}-${REDIS_CONNECTOR_VERSION}.jar && \
    ls -lh ${FLINK_LIB_DIR}/flink-s3-fs-hadoop-${FLINK_VERSION}.jar && \
    ls -lh ${FLINK_LIB_DIR}/flink-s3-fs-presto-${FLINK_VERSION}.jar

# ---------------------------------------------------------
# Permisos (OpenShift-friendly)
# ---------------------------------------------------------
USER root
RUN chmod -R 777 /opt/flink
USER flink

EXPOSE 6123 6124 6125 8081

WORKDIR ${FLINK_HOME}
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["help"]
