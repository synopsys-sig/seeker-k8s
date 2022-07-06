ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=ironbank/opensource/nginx/nginx
ARG BASE_TAG=1.21.6

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

# Build variables
ENV INSTALL_DIR=/home/seeker/seeker
ARG INSTALL_HTTP_PORT=8080
ARG INSTALL_HTTPS_PORT=8443

COPY --chown=nginx:nginx --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/nginx/conf/nginx.routes.conf ${INSTALL_DIR}/install/nginx/conf/
COPY --chown=nginx:nginx --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/data/server/certs/ ${INSTALL_DIR}/data/server/certs/
COPY --chown=nginx:nginx --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/data/server/conf/nginx.conf /etc/nginx/nginx.conf

# set pid file location
RUN echo "pid /tmp/nginx.pid;" >> /etc/nginx/nginx.conf

EXPOSE ${INSTALL_HTTP_PORT} ${INSTALL_HTTPS_PORT}

HEALTHCHECK --interval=30s --timeout=30s --retries=5 CMD curl --fail http://localhost:${INSTALL_HTTP_PORT}/rest/api/version || exit 1