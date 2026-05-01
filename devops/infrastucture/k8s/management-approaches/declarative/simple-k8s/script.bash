#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

function apply_dry() {
    kubectl apply -f . --dry-run=server
}

function apply() {
    kubectl apply -f .
}

function delete() {
    kubectl delete -f .
}

$1