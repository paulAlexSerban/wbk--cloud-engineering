#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

SERVICE_NAME=tornado-service
VERSION=0.1.0

function build() {
    docker image build -t ${SERVICE_NAME}:${VERSION} .
    docker image ls | grep ${SERVICE_NAME}
}

function run() {
    build
    docker run -p 5000:5000 -it ${SERVICE_NAME}:${VERSION}
}

$1