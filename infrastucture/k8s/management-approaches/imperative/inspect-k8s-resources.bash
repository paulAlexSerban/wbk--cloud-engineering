#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

DEPLOYMENT_NAME="my-appache"
IMAGE_NAME="httpd"

function get_info() {
    echo "---"
    echo "get k8s nodes: kubectl get nodes"
    echo "get k8s pods: kubectl get pods"
    echo "get k8s deployment: kubectl get deployment ${DEPLOYMENT_NAME} -o wide"
    echo "get k8s services: kubectl get service"
    echo "get k8s configmaps: kubectl get configmaps"
    echo "get all objects: kubectl get all"
    echo "---"
}

function create_deployment_w_replicas() {
    echo "Creating a deployment with replicas"
    kubectl create deployment ${DEPLOYMENT_NAME} --image=${IMAGE_NAME} --replicas=6
    get_info
}

function delete_deployment() {
    echo "Deleting a deployment in a specific namespace"
    kubectl delete deployment ${DEPLOYMENT_NAME}
    get_info
}

function get_deployment_info() {
    echo "Getting deployment info"
    kubectl get deployment ${DEPLOYMENT_NAME} -o wide
}

function get_deployment_info_yaml() {
    echo "Getting deployment info in yaml"
    kubectl get deployment ${DEPLOYMENT_NAME} -o yaml
}

function get_deployment_info_json() {
    echo "Getting deployment info in json"
    kubectl get deployment ${DEPLOYMENT_NAME} -o json
}

function describe_deployment_info() {
    echo "Describing deployment info"
    kubectl describe deployment ${DEPLOYMENT_NAME}
}

$1