#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

IMAGE_NAME="ubuntu"
CONTAINR_NAME="ubuntu"
PACKAGE_VERSION=latest

function run() {
    # start docker container
    docker run --detach -it \
               --name ${CONTAINR_NAME} ${IMAGE_NAME}:${PACKAGE_VERSION}

    # docker run --detach -it --name ubuntu ubuntu:latest bash

    # get the os version
    docker exec -it ${CONTAINR_NAME} cat /etc/os-release

    # run bash in the container
    docker exec -it ${CONTAINR_NAME} bash
}

function stop() {
    # stop the container
    docker stop ${CONTAINR_NAME}
}

function remove() {
    # remove the container
    docker rm ${CONTAINR_NAME}
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

$1
