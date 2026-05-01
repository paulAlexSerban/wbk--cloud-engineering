#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

# check if terraform is installed
if [[ ! -x "$(command -v terraform)" ]]; then
    echo "Terraform is not installed. Will install it with brew."
    brew install terraform
else
    terraform --version
    echo "Terraform is already installed."
fi
