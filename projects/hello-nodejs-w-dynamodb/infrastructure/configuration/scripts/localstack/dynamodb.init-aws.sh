#!/bin/bash
echo "Initializing some LocalStack resources..."

TABLE_NAME="td_notes"
REGION="us-east-1" # Change this to your AWS region

function create-db() {
    # check if table exists
    if awslocal dynamodb list-tables | grep -q $TABLE_NAME; then
        echo "Table $TABLE_NAME already exists. Skipping..."
        return
    fi

    awslocal dynamodb create-table \
        --table-name $TABLE_NAME \
        --region $REGION \
        --attribute-definitions \
        AttributeName=user_id,AttributeType=S \
        AttributeName=timestamp,AttributeType=N \
        AttributeName=title,AttributeType=S \
        AttributeName=cat,AttributeType=S \
        AttributeName=note_id,AttributeType=S \
        --key-schema \
        AttributeName=user_id,KeyType=HASH \
        AttributeName=timestamp,KeyType=RANGE \
        --local-secondary-indexes \
        "IndexName=user_id-title-index,KeySchema=[{AttributeName=user_id,KeyType=HASH},{AttributeName=title,KeyType=RANGE}],Projection={ProjectionType=ALL}" \
        "IndexName=user_id-cat-index,KeySchema=[{AttributeName=user_id,KeyType=HASH},{AttributeName=cat,KeyType=RANGE}],Projection={ProjectionType=ALL}" \
        --global-secondary-indexes \
        "IndexName=note_id-index,KeySchema=[{AttributeName=note_id,KeyType=HASH}],Projection={ProjectionType=ALL},ProvisionedThroughput={ReadCapacityUnits=1,WriteCapacityUnits=1}" \
        --billing-mode PROVISIONED \
        --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
}

create-db
