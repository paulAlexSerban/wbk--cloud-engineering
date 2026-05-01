#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

# SERICE is a stable addess for pod(s)
# if we want to connect to pod(s), we need a service
# CodeDNS allows us to resolve SERVICES by name
# There are different types of services:

# ClusterIP: default, only reachable from within the cluster
# - single, internal virtual IP allocated by K8s
# - only reachable from within the cluster (nodes and pods)
# - pods can reach service on apps port number

# NodePort: reachable from outside the cluster
# - high port allocated on each node
# - reachable from outside the cluster at NodeIP:NodePort
# - anyone can connect (if they can reach node)
# - other pods need to be updated to this port

# LoadBalancer: only works in cloud providers
# - controls an external Load Balancer endpoint to the cluster through the K8s CLI (mostly automation)
# - only available when infra provider gives you a load balancer (AWS ELB, GCP L7, Azure L4)
# - the provider load balancer will allow K8s to control it through some API
# - creates NodePort+ClusterIP services, tells LoadBalancer to send traffic to NodePort

# ExternalName: maps a service to a DNS name
# - returns a CNAME record with the DNS name
# - adds CNAME DNS record to CoreDNS only
# - not used for Pods, but for giving pods a DNS name to use for something outside K8s

DEPLOYMENT_NAME="httpenv"
IMAGE_NAME="bretfisher/httpenv"
TMP_SHELL_NAME="tmp-shell"
TMP_SHELL_IMAGE="bretfisher/netshoot"

function create_deployment() {
    echo "Creating a sample deployment"
    kubectl create deployment ${DEPLOYMENT_NAME} --image=${IMAGE_NAME}
}

function scale_replicas() {
    echo "Scaling the deployment"
    kubectl scale deployment ${DEPLOYMENT_NAME} --replicas=5
}

function expose_service_ClusterIP() {
    echo "Exposing the deployment ClusterIP on port 8888"
    kubectl expose deployment ${DEPLOYMENT_NAME} --port=8888
    echo "get the service URL: minikube service ${DEPLOYMENT_NAME} --url"
}

function expose_service_NodePort() {
    echo "Exposing the deployment NodePort on port 8888"
    kubectl expose deployment ${DEPLOYMENT_NAME} --type=NodePort --port=8888 --name=${DEPLOYMENT_NAME}-np
    echo "get the service URL: minikube service ${DEPLOYMENT_NAME}-np --url"
}

function expose_service_LoadBalancer() {
    echo "Exposing the deployment LoadBalancer on port 8888"
    kubectl expose deployment ${DEPLOYMENT_NAME} --type=LoadBalancer --port=8888 --name=${DEPLOYMENT_NAME}-lb
    echo "get the service URL: minikube service ${DEPLOYMENT_NAME}-lb --url"

    # NOTE: if you are on kubeadm, minikube, or microk8s
    # the is no built-in LoadBalancer, this is only available Docker Desktop, Rancher Desktop and cloud providers
    # you can still run the command, but it will just say at <pending> (but it's NodePort works)
}

function create_pod_and_connect_to_shell_in_cluster() {
    echo "Creating a pod and connecting to the shell in the cluster"
    kubectl run ${TMP_SHELL_NAME} --rm -it --image ${TMP_SHELL_IMAGE} -- bash
}

function delete_all() {
    echo "Deleting all deployments and services"
    kubectl delete deployment ${DEPLOYMENT_NAME}
    kubectl delete service ${DEPLOYMENT_NAME}
    kubectl delete service ${DEPLOYMENT_NAME}-np
    kubectl delete service ${DEPLOYMENT_NAME}-lb
}

$1
