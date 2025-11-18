#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

function init() {
    # this command will download the provider plugin
    terraform init
}

function plan() {
    # this command will show the changes that will be applied
    terraform plan \
        -var "filename=pet.txt" \
        -var "content=Hello, pet!" \
        -var "prefix=Mrs" \
        -var "separator=." \
        -var "length=1" 
}

function apply() {
    # this command will apply the changes
    terraform apply \
        -var "filename=pet.txt" \
        -var "content=Hello, pet!" \
        -var "prefix=Mrs" \
        -var "separator=." \
        -var "length=1" \
        -auto-approve 
}

function destroy() {
    # this command will destroy the resources
    terraform destroy -auto-approve
}

function validate() {
    # this command will validate the configuration files
    # useful when you want to check the syntax and configuration iop[]

    terraform validate
}

function formats() {
    # this command will format the configuration files
    # useful when you want to keep the files clean and consistent
    terraform fmt
}

function show() {
    # this command will show the current state
    terraform show
}

function show_json() {
    # this command will show the current state in json format
    # useful when you want to use the state in a script
    terraform show -json | jq
}

function providers() {
    # this command will show the providers
    terraform providers
}

function workspace() {
    # this command will show the current workspace
    terraform workspace show
}

function workspaces() {
    # this command will show the workspaces
    terraform workspace list
}

function refresh() {
    # this command will refresh the state
    # useful when the state is out of sync with the real world resources
    terraform refresh
}

function apply_refresh() {
    # this command will apply the changes and refresh the state
    # useful when the state is out of sync with the real world resources
    terraform apply -refresh-only
}

function graph() {
    # this command will show the graph of the resources and dependencies
    # use the following command to generate a graph file and then use a tool like graphviz to visualize it
    terraform graph
}
$1