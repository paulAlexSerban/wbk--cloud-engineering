#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

DEPLOYMENT_NAME="hello-node"

function get_info() {
    echo "get k8s nodes: kubectl get nodes"
    echo "gte k8s pods: kubectl get pods"
    echo "get k8s deployment: kubectl get deployment"
    echo "get k8s services: kubectl get service"
    echo "get k8s configmaps: kubectl get configmaps"
    echo "get all objects: kubectl get all"
}

function create_deployment_hello_node() {
    echo "Creating a sample deployment"
    kubectl create deployment ${DEPLOYMENT_NAME} --image=kicbase/echo-server:1.0
    get_info
}

function expose_service_hello_node_node_port() {
    echo "Exposing the deployment on port 8080"
    kubectl expose deployment ${DEPLOYMENT_NAME} --type=NodePort --port=8080 --name=${DEPLOYMENT_NAME}-np
    echo "get the service URL: minikube service ${DEPLOYMENT_NAME} --url"
    get_info
}

function forward_port() {
    echo "Using kubectl to forward the port"
    kubectl port-forward service/${DEPLOYMENT_NAME} 7080:8080
    echo "Now you can access the service on localhost:7080"
}

function delete_hello_node() {
    echo "Deleting the hello-node deployment"
    kubectl delete deployment ${DEPLOYMENT_NAME}
    echo "The ${DEPLOYMENT_NAME} deployment is deleted"
    get_info
}

$1
