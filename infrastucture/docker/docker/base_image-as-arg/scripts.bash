#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

REGISTRY_NAMESPACE=paulserbandev
PROJECT_NAME=$(node -p "require('./package.json').name")
PACKAGE_VERSION=$(node -p "require('./package.json').version")

function build_base_image {
    docker image build --tag ${REGISTRY_NAMESPACE}/${PROJECT_NAME}-base:${PACKAGE_VERSION} \
        --file ./Dockerfile.base .\
        --build-arg CONTAINER_PORT=${CONTAINER_PORT}
}

function build {
    docker image build --tag ${REGISTRY_NAMESPACE}/${PROJECT_NAME}-dev:${PACKAGE_VERSION} \
        --file ./Dockerfile.dev .\
        --build-arg BASE_IMAGE=${REGISTRY_NAMESPACE}/${PROJECT_NAME}-base:${PACKAGE_VERSION}
}

$1