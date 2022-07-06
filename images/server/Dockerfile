ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=ironbank/redhat/ubi/ubi8
ARG BASE_TAG=8.6

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

RUN yum -y update && \
    yum -y install fontconfig && \
    yum clean all

RUN useradd -l -m --system --uid 1000 --gid 0 seeker

WORKDIR /home/seeker

# Build variables
ENV INSTALL_DIR=/home/seeker/seeker

COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/agents/ ${INSTALL_DIR}/install/agents/
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/backup.sh ${INSTALL_DIR}/install/backup.sh
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/csv/ ${INSTALL_DIR}/install/csv/
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/integrations/ ${INSTALL_DIR}/install/integrations/
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/java/ ${INSTALL_DIR}/install/java/
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/database/ ${INSTALL_DIR}/install/database/
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/license/ ${INSTALL_DIR}/install/license/
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/licenses/ ${INSTALL_DIR}/install/licenses/
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/restore.sh ${INSTALL_DIR}/install/restore.sh
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/server/ ${INSTALL_DIR}/install/server/
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/sk_ctl ${INSTALL_DIR}/install/sk_ctl
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/data/seeker-java.security ${INSTALL_DIR}/data/seeker-java.security

COPY --chown=seeker:root docker_entrypoint.sh /home/seeker/docker_entrypoint.sh

USER 1000

HEALTHCHECK --interval=30s --timeout=30s --retries=5 CMD curl --fail http://localhost:8082/rest/api/version || exit 1

ENTRYPOINT [ "/usr/bin/bash", "/home/seeker/docker_entrypoint.sh" ]
