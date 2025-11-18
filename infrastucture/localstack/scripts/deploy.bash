#!/bin/bash
echo "Deploying Lambda to LocalStack..."

# Build ZIP package inside Docker
docker build -t lambda-builder src/hello_lambda
docker run --rm -v $(pwd)/dist:/output lambda-builder

# Upload to LocalStack S3
awslocal s3 cp dist/lambda.zip s3://local-lambda-bucket/lambda.zip

# Create Lambda function
awslocal lambda create-function \
    --function-name hello-world \
    --runtime nodejs18.x \
    --handler index.handler \
    --memory-size 128 \
    --timeout 10 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --code S3Bucket=local-lambda-bucket,S3Key=lambda.zip
