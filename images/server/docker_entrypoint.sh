#!/usr/bin/env bash

export SEEKER_INSTALL_DIR="${INSTALL_DIR}/install"
export SEEKER_HOME_DIR="${INSTALL_DIR}/data"
export PATH="${SEEKER_INSTALL_DIR}:${SEEKER_INSTALL_DIR}/database/bin:${SEEKER_INSTALL_DIR}/license/bin:${SEEKER_INSTALL_DIR}/java/jdk-11.0.15+10/bin:${PATH}"

# setup db password
if [ -f /opt/seeker/secrets/dbpass ];
then
    mkdir -p "${SEEKER_HOME_DIR}/server/conf"
    cp -f /opt/seeker/secrets/dbpass "${SEEKER_HOME_DIR}/server/conf/dbpass"
else
    echo "ERROR: password file /opt/seeker/dbpass is missing!!"
    exit 1
fi

# remove the liquibase lock
export PGPASSWORD="$(cat "${SEEKER_HOME_DIR}"/server/conf/dbpass)"
echo "Removing the Liquibase lock if it exists..."
psql -t -A -h "${SEEKER_SERVER_DB_HOST}" \
    -p "${SEEKER_SERVER_DB_PORT}" \
    -U "${SEEKER_SERVER_DB_USER}" \
    -d "${SEEKER_SERVER_DB_NAME}" \
    -c "UPDATE databasechangeloglock SET locked = false WHERE id = 1" \
    echo "Did not find or could not remove the Liquibase lock"
unset PGPASSWORD

if [ -z "${SEEKER_SERVER_JAVA_OPTS}" ];
then
    SEEKER_SERVER_JAVA_OPTS="-Xmx4096m"
fi

exec java \
        -cp \
        "${SEEKER_INSTALL_DIR}"/server/commons-io-2.11.0.jar:"${SEEKER_INSTALL_DIR}"/server/* \
        -XX:+HeapDumpOnOutOfMemoryError \
        -XX:HeapDumpPath="/tmp/server.temp.hprof" \
        -XX:+ExitOnOutOfMemoryError \
        -Dliquibase.csvdir="${SEEKER_INSTALL_DIR}"/csv \
        -Djava.security.properties="${SEEKER_HOME_DIR}/seeker-java.security" \
        -Djava.awt.headless=true \
        ${SEEKER_SERVER_JAVA_OPTS} \
        -Ddw.logging.appenders[0].threshold=ALL \
        com.synopsys.seeker.server.SeekerServer
