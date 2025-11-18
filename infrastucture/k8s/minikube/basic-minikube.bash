#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

function start_k8s() {
    echo "Starting the local Kubernetes minikube cluster"
    minikube start
    echo "The minikube cluster is started"
}

function stop_k8s() {
    echo "Stopping the Kubernetes minikube cluster"
    minikube stop
    echo "The cluster is stopped - deployed apps were not deleted"
    echo "To start the cluster again, run 'minikube start' - if you ahve issues, run 'minikube delete' and then 'minikube start'"
}

function create_service_hello_minikube() {
    echo "Creating a sample deployment and exposing it on port 8080"
    kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
}

function expose_service_hello_minikube() {
    echo "Exposing the deployment on port 8080"
    kubectl expose deployment hello-minikube --type=NodePort --port=8080
}

function get_service_hello_minikube() {
    echo "Getting the service URL"
    minikube service hello-minikube --url
}

function use_kubectl_to_forward_port() {
    echo "Using kubectl to forward port 8080 to 8080"
    kubectl port-forward service/hello-minikube 7080:8080
    echo "Now you can access the service on localhost:7080"
}

function pause_k8s() {
    echo "Pausing the Kubernetes cluster"
    minikube pause
    echo " The cluster is paused - deployed apps were not deleted"
}

function unpause_k8s() {
    echo "Unpausing the Kubernetes cluster"
    minikube unpause
    echo "The cluster is unpaused"
}
 function delete_all() {
    echo "Deleting all deployments and services"
    minikube delete --all
    echo "All deployments and services are deleted"
 }

