ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=ironbank/redhat/ubi/ubi8
ARG BASE_TAG=8.6

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

RUN useradd -l -m --system --uid 1000 --gid 0 seeker
WORKDIR /home/seeker

# Build variables
ENV INSTALL_DIR=/home/seeker/seeker

COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/csv/ ${INSTALL_DIR}/install/csv/
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/java/ ${INSTALL_DIR}/install/java/
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/sensor/ ${INSTALL_DIR}/install/sensor/
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/install/agents/2022.6.0/corvus/ ${INSTALL_DIR}/install/agents/2022.6.0/corvus/
COPY --chown=seeker:root --from=seeker-local/seeker-installer:2022.6.0 ${INSTALL_DIR}/data/seeker-java.security ${INSTALL_DIR}/data/seeker-java.security

COPY --chown=seeker:root docker_entrypoint.sh /home/seeker/docker_entrypoint.sh

USER 1000

HEALTHCHECK --interval=30s --timeout=30s --retries=5 CMD curl --fail http://localhost:9911/rest || exit 1

ENTRYPOINT ["/home/seeker/docker_entrypoint.sh"]
