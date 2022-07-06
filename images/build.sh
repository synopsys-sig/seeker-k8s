#!/bin/sh

set -e

if [ -z "${DOCKER_REGISTRY}" ];
then
    echo "DOCKER_REGISTRY env var is missing"
    exit 1
fi

buildImage() {
    COMPONENT=$1
    BASE_REGISTRY=$2
    BASE_IMAGE=$3
    sed -i.bak "s|seeker-local|${DOCKER_REGISTRY}|g" "./${COMPONENT}/Dockerfile"
    docker build \
        --build-arg BASE_IMAGE="${BASE_IMAGE}" \
        --build-arg BASE_REGISTRY="${BASE_REGISTRY}" \
        -t "${DOCKER_REGISTRY}/seeker-${COMPONENT}:2022.6.0" "${COMPONENT}"
    rm "./${COMPONENT}/Dockerfile"
    mv "./${COMPONENT}/Dockerfile.bak" "./${COMPONENT}/Dockerfile"
}

if [ -z "${PLATFORM_ONE}" ];
then
    buildImage installer registry.access.redhat.com ubi8/ubi
    buildImage postgres index.docker.io postgres
    buildImage server registry.access.redhat.com ubi8/ubi
    buildImage sensor registry.access.redhat.com ubi8/ubi
    buildImage nginx index.docker.io nginx
else    
    buildImage installer registry1.dso.mil ironbank/redhat/ubi/ubi8
    buildImage postgres registry1.dso.mil ironbank/opensource/postgres/postgresql10
    buildImage server registry1.dso.mil ironbank/redhat/ubi/ubi8
    buildImage sensor registry1.dso.mil ironbank/redhat/ubi/ubi8
    buildImage nginx registry1.dso.mil ironbank/opensource/nginx/nginx
fi

if [ "${DOCKER_REGISTRY}" != "seeker-local" ];
then
    echo "Pushing Seeker images to: ${DOCKER_REGISTRY}"
    docker push "${DOCKER_REGISTRY}/seeker-postgres:2022.6.0"
    docker push "${DOCKER_REGISTRY}/seeker-server:2022.6.0"
    docker push "${DOCKER_REGISTRY}/seeker-sensor:2022.6.0"
    docker push "${DOCKER_REGISTRY}/seeker-nginx:2022.6.0"
fi
