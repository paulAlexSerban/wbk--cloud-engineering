#!/bin/bash
echo "Initializing some LocalStack resources..."

# Create an S3 bucket for Lambda deployments
awslocal s3 mb s3://repo-packages-lambda
