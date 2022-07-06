ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=ironbank/redhat/ubi/ubi8
ARG BASE_TAG=8.6

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as base_image

# Install Required Packages
RUN yum -y update && yum install -y glibc-langpack-en && \
    yum clean all

RUN useradd -l -m --system --uid 1000 --gid 0 seeker

################ Install Seeker
FROM base_image as base_install

# Build variables
ARG INSTALL_DIR=/home/seeker/seeker
ARG INSTALL_HTTP_PORT=8080
ARG INSTALL_HTTPS_PORT=8443

# Copy Installer
COPY --chown=seeker:root seeker-server-*.sh /tmp/seeker-server.sh

# Switch to Seeker User
USER 1000
WORKDIR /tmp

# Run Installer
RUN sh /tmp/seeker-server.sh \
        accept-license=agree \
        install-dir=${INSTALL_DIR} \
        server-http-port=${INSTALL_HTTP_PORT} \
        server-https-port=${INSTALL_HTTPS_PORT} \
    && rm /tmp/seeker-server.sh \
    && mkdir -p ${INSTALL_DIR}/install/nginx/client_body_temp \
    && mkdir -p ${INSTALL_DIR}/install/nginx/proxy_temp \
    && mkdir -p ${INSTALL_DIR}/install/nginx/fastcgi_temp \
    && mkdir -p ${INSTALL_DIR}/install/nginx/uwsgi_temp \
    && mkdir -p ${INSTALL_DIR}/install/nginx/scgi_temp \
    && chmod -R g+rwX ${INSTALL_DIR}

################ Copy Install files and Prepare to Start
FROM base_image

# Build variables
ARG INSTALL_DIR=/home/seeker/seeker

# Switch to Seeker User
USER 1000
WORKDIR /home/seeker

# Copy Installation Files
COPY --chown=seeker:root --from=base_install ${INSTALL_DIR} ${INSTALL_DIR}

# update nginx server/sensor hosts
RUN sed -i "s|127.0.0.1:8082|seeker-server-service:8082|g" ${INSTALL_DIR}/data/server/conf/nginx.conf && \
    sed -i "s|127.0.0.1:9911|seeker-sensor-service:9911|g" ${INSTALL_DIR}/data/server/conf/nginx.conf
