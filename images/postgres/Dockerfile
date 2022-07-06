ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=ironbank/opensource/postgres/postgresql10
ARG BASE_TAG=10.19

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

HEALTHCHECK --interval=30s --timeout=30s --retries=5 CMD pg_isready --port=5432 --quiet || exit 1