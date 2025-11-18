#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

DEPLOYMENT_NAME="my-appache"
IMAGE_NAME="httpd"

function get_info() {
    echo "get k8s nodes: kubectl get nodes"
    echo "get k8s pods: kubectl get pods"
    echo "get k8s deployment: kubectl get deployment"
    echo "get k8s services: kubectl get service"
    echo "get k8s configmaps: kubectl get configmaps"
    echo "get all objects: kubectl get all"
}

function create_deployment() {
    echo "Creating a deployment in a specific namespace"
    kubectl create deployment ${DEPLOYMENT_NAME} --image=${IMAGE_NAME}
    get_info
}

function scale_replicas() {

    echo "Scaling the deployment"
    kubectl scale deployment ${DEPLOYMENT_NAME} --replicas=2
    get_info

    # when we scale the deployment, we are scaling the number of pods
    # kubectl scale will CHANGE the deployment record
    # CM will see that ONLY replica count has changed
    # it will change the number of pods in ReplicaSet
    # Schecduler sees a new pod is requested, assigns a node
    # Kubelet sees a new pod, and tells container runtime to start the container
}

function create_deployment_w_replicas() {
    echo "Creating a deployment with replicas"
    kubectl create deployment ${DEPLOYMENT_NAME} --image=${IMAGE_NAME} --replicas=3
    get_info
}

function delete_deployment() {
    echo "Deleting a deployment in a specific namespace"
    kubectl delete deployment ${DEPLOYMENT_NAME}
    get_info
}

$1