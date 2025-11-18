#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

function get_k8s_namespace() {
    echo "Getting the list of namespaces"
    kubectl get namespaces
}

function specify_namespace() {
    echo "Specifying the namespace"
    # kubectl get pods --namespace=<NAMESPACE_NAME>
    kubectl get pods --namespace=kube-system
}

function create_namespace() {
    echo "Creating a new namespace"
    # kubectl create namespace <NAMESPACE_NAME>
    kubectl create namespace my-namespace
}

function get_all_namespaces() {
    echo "Getting all namespaces"
    # kubectl get namespaces
    kubectl get pods --all-namespaces
}

function create_namespace() {
    echo "Creating a new namespace"
    # kubectl create namespace <NAMESPACE_NAME>
    kubectl create namespace my-namespace
}

$1