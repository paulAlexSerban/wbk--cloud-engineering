#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

DEPLOYMENT_NAME="my-appache"
IMAGE_NAME="httpd"

function watch_deployment() {
    echo "Watching deployment"
    kubectl get deployment ${DEPLOYMENT_NAME} --watch
}

function watch_only_events() {
    echo "Watching only events"
    kubectl get events --watch
}