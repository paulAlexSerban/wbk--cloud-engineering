#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

# all `kubectl get` commands use helper templates called "geenraors"
# every resource in K8s has a specification or "spec"

DEPLOYMENT_NAME="my-appache"
IMAGE_NAME="httpd"

function output_deploy_yaml() {
    kubectl create deployment ${DEPLOYMENT_NAME} --image=${IMAGE_NAME} --dry-run=client -o yaml
}

function output_deploy_yaml_to_file() {
    kubectl create deployment ${DEPLOYMENT_NAME} --image=${IMAGE_NAME} --dry-run=client -o yaml >deployment.yaml
}

# these yaml files can be used as starting points for creating new resources
# generators are "opintionated" and may not be the best starting point for all resources

function output_job_yaml() {
    kubectl create job ${DEPLOYMENT_NAME} --image=${IMAGE_NAME} --dry-run=client -o yaml
}

function output_job_yaml_to_file() {
    kubectl create job ${DEPLOYMENT_NAME} --image=${IMAGE_NAME} --dry-run=client -o yaml >job.yaml
}

function output_expose_deployment_yaml() {
    kubectl expose deployment ${DEPLOYMENT_NAME} --port=80 --dry-run=client -o yaml
    echo "---"
    echo "you need the deployment to exist before you can expose it"
}

function output_expose_deployment_yaml_to_file() {
    kubectl expose deployment ${DEPLOYMENT_NAME} --port=80 --dry-run=client -o yaml >expose.yaml
    echo "you need the deployment to exist before you can expose it"
}

$1
