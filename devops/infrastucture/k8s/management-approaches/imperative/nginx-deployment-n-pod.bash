#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

DEPLOYMENT_NAME="my-nginx"
IMAGE_NAME="nginx"

function get_info() {
    echo "get k8s nodes: kubectl get nodes"
    echo "gte k8s pods: kubectl get pods"
    echo "get k8s deployment: kubectl get deployment"
    echo "get k8s services: kubectl get service"
    echo "get k8s configmaps: kubectl get configmaps"
    echo "get all objects: kubectl get all"
}

function run_my-nginx_pod() {
    echo "Running a pod in a specific namespace"
    # kubectl run my-nginx --image=nginx
    kubectl run ${DEPLOYMENT_NAME} --image=${IMAGE_NAME}
    # run only creates a pod, it does not create a deployment
    # it is unlikely that you will use run in a production environment unless you are debugging

    get_info
}

function create_deployment() {
    echo "Creating a deployment in a specific namespace"
    # kubectl create deployment <DEPLOYMENT_NAME> --image=<IMAGE_NAME>
    kubectl create deployment ${DEPLOYMENT_NAME} --image=${IMAGE_NAME}
    # NOTE: you can't have two resources of the same resource with the same name in the same namespace
    # a deployment is a resource, not a pod
    # deplyment creates a replicaset and a pod
    # a replicaset is a resource that creates a pod

    get_info
}

function delete_pod() {
    echo "Deleting a pod in a specific namespace"
    # kubectl delete pod <POD_NAME>
    kubectl delete pod ${DEPLOYMENT_NAME}

    get_info
}

function delete_deployment() {
    echo "Deleting a deployment in a specific namespace"
    # kubectl delete deployment <DEPLOYMENT_NAME>
    kubectl delete deployment ${DEPLOYMENT_NAME}

    get_info
}

$1