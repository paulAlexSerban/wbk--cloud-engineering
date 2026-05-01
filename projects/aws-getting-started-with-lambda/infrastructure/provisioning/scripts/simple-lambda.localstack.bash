#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

APP_NAME=""
# inspired from maven phases (https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)
PHASE=""
STAGE="local"
FUNCTION_SHA256SUM=""

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

function create-api-gateway() {
    API_ID=$(awslocal apigateway create-rest-api --name "${APP_NAME}-api" --query "id" --output text)
    API_GATEWAY_PARENT_RESOURCE_ID=$(awslocal apigateway get-resources --rest-api-id "$API_ID" --query "items[0].id" --output text) 
    RESOURCE_ID=$(awslocal apigateway create-resource --rest-api-id "$API_ID"  --path-part "${APP_NAME}" --query "id" --output text --parent-id "${API_GATEWAY_PARENT_RESOURCE_ID}")

    awslocal apigateway put-method --rest-api-id "$API_ID" \
        --resource-id "$RESOURCE_ID" \
        --http-method ANY \
        --authorization-type "NONE" 

    awslocal apigateway put-integration \
        --rest-api-id "$API_ID" \
        --resource-id "$RESOURCE_ID" \
        --http-method ANY \
        --integration-http-method POST \
        --type AWS_PROXY \
        --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:${APP_NAME}/invocations
}

function install-lambda() {
    build
    echo "[ 🚀 ] --- install package in local development setup"
    if [[ $(awslocal s3api list-buckets --query "Buckets[?Name=='repo-packages-lambda'].Name" --output text) != "repo-packages-lambda" ]]; then
        awslocal s3 mb s3://repo-packages-lambda
    else
        echo "[ ℹ️ ] --- bucket already exists"
    fi

    FUNCTION_SHA256SUM=$(sha256sum ../../../backend/functions/${APP_NAME}/dist/function.zip | awk '{print $1}')
    
    awslocal s3 cp ../../../backend/functions/${APP_NAME}/dist/function.zip s3://repo-packages-lambda/${APP_NAME}/${FUNCTION_SHA256SUM}.zip
}

function deploy-lambda() {
    if [[ $(awslocal lambda list-functions --query "Functions[?FunctionName=='${APP_NAME}'].FunctionName" --output text) == "${APP_NAME}" ]]; then
        awslocal lambda delete-function --function-name ${APP_NAME}
    fi

    awslocal lambda create-function \
        --function-name ${APP_NAME} \
        --runtime nodejs22.x \
        --handler index.handler \
        --memory-size 128 \
        --timeout 10 \
        --role arn:aws:iam::000000000000:role/lambda-role \
        --code S3Bucket=repo-packages-lambda,S3Key=${APP_NAME}/${FUNCTION_SHA256SUM}.zip \
        --no-cli-pager
}

function expose-api-gateway() {
    API_ID=$(awslocal apigateway get-rest-apis --query "items[-1].id" --output text)
    awslocal apigateway create-deployment \
        --rest-api-id "${API_ID}" \
        --stage-name "${STAGE}" 

    echo "http://localhost:4566/_aws/execute-api/<apiId>/<stageName>/<path>"
    echo "API Gateway URL: http://localhost:4566/_aws/execute-api/${API_ID}/${STAGE}/${APP_NAME}"
    echo "API Gateway URL: http://localhost:4566/restapis/${API_ID}/${STAGE}/_user_request_/${APP_NAME}"
}

function deploy() {
    echo "[ 🚀 ] --- deploy the lambda function"
    create-api-gateway
    install-lambda
    deploy-lambda
    expose-api-gateway
}

$PHASE && echo "[ ✅ ] --- done deploying lambda" || echo "[ 🚫 ] --- failed deploying lambda"
