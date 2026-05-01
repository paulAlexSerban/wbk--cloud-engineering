#!/bin/bash
echo "Initializing LocalStack resources..."

# Create an S3 bucket for Lambda deployments
awslocal s3 mb s3://local-lambda-bucket

# Create a DynamoDB table
awslocal dynamodb create-table \
    --table-name HelloTable \
    --attribute-definitions AttributeName=ID,AttributeType=S \
    --key-schema AttributeName=ID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST

# Create an API Gateway
API_ID=$(awslocal apigateway create-rest-api --name "HelloAPI" --query "id" --output text)
RESOURCE_ID=$(awslocal apigateway create-resource --rest-api-id "$API_ID" --parent-id $(awslocal apigateway get-resources --rest-api-id "$API_ID" --query "items[0].id" --output text) --path-part "{proxy+}" --query "id" --output text)

awslocal apigateway put-method --rest-api-id "$API_ID" \
    --resource-id "$RESOURCE_ID" \
    --http-method ANY \
    --authorization-type "NONE"
awslocal apigateway put-integration --rest-api-id "$API_ID" \
    --resource-id "$RESOURCE_ID" \
    --http-method ANY \
    --type AWS_PROXY \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:hello-world/invocations
