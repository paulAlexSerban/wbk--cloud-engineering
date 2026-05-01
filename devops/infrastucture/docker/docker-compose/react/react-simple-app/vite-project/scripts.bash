#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

PACKAGE_VERSION=$(node -p -e "require('./package.json').version")

function build_docker_image_dev() {
	docker build -t react-v2:${PACKAGE_VERSION}--dev -f Dockerfile.dev .
	docker build -t react-v2:latest -f Dockerfile.dev .
}

function build_docker_image_prod() {
	docker build -t react-v2:${PACKAGE_VERSION} -f Dockerfile.prod .
	docker build -t react-v2:latest -f Dockerfile.prod .
}

function run_docker_container_dev() {
	docker run -d -p 8080:5173 react-v2:${PACKAGE_VERSION}--dev
}

function run_docker_container_prod() {
	docker run -d -p 8080:80 react-v2:${PACKAGE_VERSION}
}

function stop_docker_container() {
	docker stop $(docker ps -q --filter ancestor=react-v2)
}

function remove_docker_container() {
	docker rm $(docker ps -a -q --filter ancestor=react-v2)
}

function run_docker_container_latest() {
	docker run -d -p 8080:80 react-v2:latest
}

function start-compose() {
	docker compose down && docker compose up --build
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
