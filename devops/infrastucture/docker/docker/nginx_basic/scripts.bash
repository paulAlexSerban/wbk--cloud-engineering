#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

IMAGE_NAME=custom_nginx
CONTAINER_NAME=custom_nginx

PACKAGE_VERSION="0.0.0"

HOST_PORT=8080
CONTAINER_PORT=80

IMAGE_REGISTRY_NAMESPACE=paulserbandev

if [ -z "$1" ]; then
    help
    exit 1
fi

function help() {
    echo "Available commands:"
    echo "build - build the Docker image"
    echo "run - run the Docker container"
    echo "list_images - list all Docker images"
    echo "list_containers - list all Docker containers"
    echo "stop - stop the Docker container"
    echo "remove - remove the Docker container"
}

function list_images() {
    docker image ls | grep ${IMAGE_NAME}
}

function list_containers() {
    docker ps | grep ${CONTAINER_NAME}
}

function build() {
    docker image build --tag ${IMAGE_REGISTRY_NAMESPACE}/${IMAGE_NAME}:${PACKAGE_VERSION} \
        --tag ${IMAGE_REGISTRY_NAMESPACE}/${IMAGE_NAME}:latest . \
        --build-arg CONTAINER_PORT=${CONTAINER_PORT}
    list_images
}

function stop() {
    # stop the container
    docker stop ${CONTAINER_NAME}
}

function remove() {
    # remove the container
    docker rm ${CONTAINER_NAME}
    list_containers
}

function run() {
    stop
    remove
    docker run --detach --name ${CONTAINER_NAME} \
        -p ${HOST_PORT}:${CONTAINER_PORT} ${IMAGE_REGISTRY_NAMESPACE}/${IMAGE_NAME}:latest
    list_containers
    echo "Server listening to http://localhost:${HOST_PORT}" # Fixed message to use HOST_PORT
}

function push() {
    docker push ${IMAGE_REGISTRY_NAMESPACE}/${IMAGE_NAME}:${PACKAGE_VERSION}
    docker push ${IMAGE_REGISTRY_NAMESPACE}/${IMAGE_NAME}:latest
}

function logs() {
    docker logs ${CONTAINER_NAME}
}

function clean_system() {
    echo "Disk usage before cleanup:"
    docker system df
    
    echo "Pruning all unused images..."
    docker image prune -a -f
    
    echo "Pruning all stopped containers..."
    docker container prune -f
    
    echo "Pruning all unused volumes..."
    docker volume prune -f
    
    echo "Pruning all unused networks..."
    docker network prune -f
    
    echo "Disk usage after cleanup:"
    docker system df
}

$1 && echo "Done" || echo "Failed"
