#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

function help() {
    echo "Usage: $0 <up|up-new|down>"
    echo "up: starts the containers"
    echo "up-new: starts the containers and recreates them"
    echo "down: stops the containers and removes the volumes"
}

if [ -z "$1" ]; then
    help
    exit 1
fi

ENV_FILE="./env/.env"
COMPOSE_FILE="./docker-compose.yaml"
HOST_DIR_NAME=$(basename $(pwd))
COMPOSE_PROJECT_NAME=${HOST_DIR_NAME//-/_}

function up() {
    echo "[ 🟢 🐳 compose up ]"
    docker compose \
        --env-file ${ENV_FILE} \
        --file ${COMPOSE_FILE} up \
        --detach --build \
         drupal-web-server
}

function up-new() {
    echo "[ 🟢 🐳 compose up new ]"
    docker-compose \
        --env-file ${ENV_FILE} \
        --file ${COMPOSE_FILE} up \
        --detach --build \
        --force-recreate \
         drupal-web-server
}

function down() {
    echo "[ 🛑 🐳 compose down ]"
    docker compose \
        --env-file ${ENV_FILE} \
        --file ${COMPOSE_FILE} down \
        --volumes --rmi all
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
