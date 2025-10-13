FROM flink:1.19.0-scala_2.13

LABEL maintainer="damian.ruiz"
LABEL description="Flink 1.19"
LABEL version="redis-lab3"

ENV FLINK_HOME=/opt/flink
ENV FLINK_LIB_DIR=${FLINK_HOME}/lib
ARG REDIS_CONNECTOR_VERSION=1.1.0
ARG SCALA_VERSION=2.13

RUN wget -q https://repo1.maven.org/maven2/org/apache/bahir/flink-connector-redis_${SCALA_VERSION}/${REDIS_CONNECTOR_VERSION}/flink-connector-redis_${SCALA_VERSION}-${REDIS_CONNECTOR_VERSION}.jar \
    -O ${FLINK_LIB_DIR}/flink-connector-redis_${SCALA_VERSION}-${REDIS_CONNECTOR_VERSION}.jar

RUN ls -lh ${FLINK_LIB_DIR}/flink-connector-redis_${SCALA_VERSION}-${REDIS_CONNECTOR_VERSION}.jar
USER root
RUN chmod -R 777 /opt/flink
USER flink
EXPOSE 6123 6124 6125 8081

WORKDIR ${FLINK_HOME}
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["help"]