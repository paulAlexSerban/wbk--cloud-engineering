#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

# check if awslocal is installed

if [[ ! -x "$(command -v awslocal)" ]]; then
    echo "awslocal is not installed."
    echo "will install awslocal with brew"
    brew install awscli-local
fi
