#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

APP_NAME=""
# inspired from maven phases (https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)
PHASE=""
FUNCTION_SHA256SUM="(known after apply)"
STAGE="local"

for arg in "$@"; do
    case $arg in
    --app-name=*)
        APP_NAME="${arg#*=}"
        shift
        ;;
    --phase=*)
        PHASE="${arg#*=}"
        shift
        ;;
    esac
done

if [ -z "$APP_NAME" ]; then
    echo "Please provide the app name"
    exit 1
fi

if [ -z "$PHASE" ]; then
    echo "Please provide the phase"
    exit 1
fi

ENV_FILE="../../configuration/env/.${APP_NAME}.compose.env"
. ${ENV_FILE}

export TF_VAR_aws_access_key
export TF_VAR_aws_secret_key

function install-lambda() {
    echo "[ 🚀 ] --- install package in local development setup"
    if [[ $(awslocal s3api list-buckets --query "Buckets[?Name=='repo-packages-lambda'].Name" --output text) != "repo-packages-lambda" ]]; then
        awslocal s3 mb s3://repo-packages-lambda
    else
        echo "[ ℹ️ ] --- bucket already exists"
    fi

    FUNCTION_SHA256SUM=$(sha256sum ../../../backend/functions/${APP_NAME}/dist/function.zip | awk '{print $1}')
    
    awslocal s3 cp ../../../backend/functions/${APP_NAME}/dist/function.zip s3://repo-packages-lambda/${APP_NAME}/${FUNCTION_SHA256SUM}.zip
}

function tf-init() {
    echo "[ 🏗️ 🐳 ] --- init terraform"
    terraform -chdir=. init \
        -var "function_name=${APP_NAME}" \
        -var "function_sha256sum=${FUNCTION_SHA256SUM}" \
        -var "stage=${STAGE}"

    terraform -chdir=. plan \
        -var "function_name=${APP_NAME}" \
        -var "function_sha256sum=${FUNCTION_SHA256SUM}"\
        -var "stage=${STAGE}" 
}

function tf-apply() {
    install-lambda
    echo "[ 🚀 ] --- apply terraform"
    terraform -chdir=. apply -auto-approve \
        -var "function_name=${APP_NAME}" \
        -var "function_sha256sum=${FUNCTION_SHA256SUM}"\
        -var "stage=${STAGE}" 

    INVOKE_URL=$(terraform -chdir=. output api_gateway_invoke_url | tr -d '"')
    echo "API Gateway URL: ${INVOKE_URL}"
}

function tf-destroy() {
    echo "[ 🧨 ] --- destroy terraform"
    terraform -chdir=. destroy -auto-approve \
        -var "function_name=${APP_NAME}" \
        -var "function_sha256sum=${FUNCTION_SHA256SUM}"\
        -var "stage=${STAGE}" 
}

$PHASE && echo "[ ✅ ] --- done" || echo "[ 🚫 ] --- failed"