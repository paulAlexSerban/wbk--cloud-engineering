#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

DEPLOYMENT_NAME="my-appache"
IMAGE_NAME="httpd"

function get_logs() {
    echo "Getting logs from a pod"
    kubectl logs deploy/${DEPLOYMENT_NAME}
}

function get_n_tail_logs() {
    echo "Getting logs from a pod"
    kubectl logs deploy/${DEPLOYMENT_NAME} --tail 5
}

function get_specific_container_logs_in_pod() {
    echo "Getting logs from a specific container in a pod"
    kubectl logs deploy/${DEPLOYMENT_NAME} -c ${IMAGE_NAME}
}

function get_specific_container_logs_in_pod() {
    echo "Getting logs from all containers in a pod"
    kubectl logs deploy/${DEPLOYMENT_NAME} --all-containers=true
}

function get_multiple_pods_logs() {
    echo "Getting logs from multiple pods"
    kubectl logs -l app=${DEPLOYMENT_NAME}
}

$1