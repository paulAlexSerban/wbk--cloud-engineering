#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

function apply_dry() {
    # --dry-run=server will simulate the apply, but not actually do it
    kubectl apply -f . --dry-run=server
}

function apply() {
    # apply the configuration
    kubectl apply -f .
}

function diff() {
    # show the difference between the current configuration and the configuration in the file
    kubectl diff -f .
}

function delete() {
    # delete the configuration
    kubectl delete -f .
}

$1