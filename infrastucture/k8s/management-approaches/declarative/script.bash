#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

function get_supported_api_resources() {
    echo "Getting the list of supported API resources"
    kubectl api-resources
    # notice that some resources have multiple APIs (old vs new)
}

function get_supported_api_versions() {
    echo "Getting the list of supported API versions"
    kubectl api-versions
}

function get_all_the_keys_each_kind_supports() {
    echo "Getting all the keys each kind supports"
    kubectl explain services --recursive
}

function get_all_the_keys_each_kind_supports_spec() {
    echo "Getting all the keys each kind supports"
    kubectl explain services.spec
}

function get_all_the_keys_each_kind_supports_type() {
    echo "Getting all the keys each kind supports"
    kubectl explain services.spec.type
}