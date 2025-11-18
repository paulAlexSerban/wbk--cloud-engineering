#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

if [ -z "$1" ]; then
    help
    exit 1
fi

TAG=nodejs-utility-container
USER_ID=$(id -u)
GROUP_ID=$(id -g)

function build {
    docker build \
        -t ${TAG}:cliuser \
        --build-arg USER_ID=${USER_ID} \
        --build-arg GROUP_ID=${GROUP_ID} .
}

function build_new() {
    docker build \
        -t ${TAG}:cliuser \
        --build-arg USER_ID=${USER_ID} \
        --build-arg GROUP_ID=${GROUP_ID} \
        --no-cache .
}

function init {
    docker run -it --rm \
        -v "$(pwd):/app" \
        -w /app ${TAG}:cliuser init
}

function install {
    docker run -it --rm \
        -v "$(pwd):/app" \
        -w /app ${TAG}:cliuser \
        install express --save
}

function compose_init {
    docker compose run --rm \
        npm init
}

function compose_install {
    docker compose run --rm \
        npm install express --save
}

$1
