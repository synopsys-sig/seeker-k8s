#!/usr/bin/env bash

export SEEKER_INSTALL_DIR="${INSTALL_DIR}/install"
export SEEKER_HOME_DIR="${INSTALL_DIR}/data"
export PATH="${SEEKER_INSTALL_DIR}/java/jdk-11.0.15+10/bin:${PATH}"

# setup db password
if [ -f /opt/seeker/secrets/dbpass ];
then
    mkdir -p "${SEEKER_HOME_DIR}/server/conf"
    cp -f /opt/seeker/secrets/dbpass "${SEEKER_HOME_DIR}/server/conf/dbpass"
else
    echo "ERROR: password file /opt/seeker/dbpass is missing!!"
    exit 1
fi

if [ -z "${SEEKER_SENSOR_JAVA_OPTS}" ];
then
    SEEKER_SENSOR_JAVA_OPTS="-Xmx4096m"
fi

exec java \
        -cp \
        "${SEEKER_INSTALL_DIR}/sensor/*" \
        -XX:+HeapDumpOnOutOfMemoryError \
        -XX:HeapDumpPath="/tmp/sensor.temp.hprof" \
        -XX:+ExitOnOutOfMemoryError \
        -Djava.security.properties="${SEEKER_HOME_DIR}/seeker-java.security" \
        ${SEEKER_SENSOR_JAVA_OPTS} \
        -Ddw.logging.appenders[0].threshold=ALL \
        com.synopsys.seeker.collector.SeekerCollector
