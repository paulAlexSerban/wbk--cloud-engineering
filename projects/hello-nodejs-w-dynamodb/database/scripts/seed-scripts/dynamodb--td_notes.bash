#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit
echo "Initializing some LocalStack resources..."

LOREM_STRING="lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt mollit anim id est laborum"
TABLE_NAME="td_notes"
REGION="us-east-1" # Change this to your AWS region

generate_string() {
    local COUNT=$1
    echo $LOREM_STRING | tr ' ' '\n' | shuf | head -n $COUNT | tr '\n' ' ' | xargs
}

generate_number() {
    local COUNT=$1
    echo $((RANDOM % $COUNT + 1))
}

generate_status() {
    if [ $((RANDOM % 2)) -eq 0 ]; then
        echo "passed"
    else
        echo "failed"
    fi
}

function create-db() {
    # Create a DynamoDB table
    awslocal dynamodb create-table \
        --table-name $TABLE_NAME \
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
        --global-secondary-indexes '[
            {
                "IndexName": "note_id-index",
                "KeySchema": [
                    {
                        "AttributeName": "note_id",
                        "KeyType": "HASH"
                    }
                ],
                "Projection": {
                    "ProjectionType": "ALL"
                },
                "ProvisionedThroughput": {
                    "ReadCapacityUnits": 1,
                    "WriteCapacityUnits": 1
                }
            },
            {
                "IndexName": "user_id-index",
                "KeySchema": [
                    {
                        "AttributeName": "user_id",
                        "KeyType": "HASH"
                    }
                ],
                "Projection": {
                    "ProjectionType": "ALL"
                },
                "ProvisionedThroughput": {
                    "ReadCapacityUnits": 1,
                    "WriteCapacityUnits": 1
                }
            }
        ]' \
        --billing-mode PROVISIONED \
        --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
        --no-cli-pager
}

function add-item() {
    local COUNT=$1
    local USER_ID="user_$(generate_number 10)"
    local TIMESTAMP=$(date +%s) # Current timestamp (seconds)
    local TITLE="title_$(generate_string 5)"
    local CATEGORY="cat_$(generate_number 5)"
    local NOTE_ID="note_$(generate_number 10000)"
    local NOTE_CONTENT="content_$(generate_string 10)"

    echo "Inserting item $COUNT..."

    # Construct the JSON payload using jq
    JSON_PAYLOAD=$(jq -n \
        --arg user_id "$USER_ID" \
        --arg timestamp "$TIMESTAMP" \
        --arg title "$TITLE" \
        --arg cat "$CATEGORY" \
        --arg note_id "$NOTE_ID" \
        --arg content "$NOTE_CONTENT" \
        '{
        user_id: {S: $user_id},
        timestamp: {N: ($timestamp | tostring)},
        title: {S: $title},
        cat: {S: $cat},
        note_id: {S: $note_id},
        content: {S: $content}
    }')

    # Run the AWS CLI command with the properly formatted JSON
    awslocal dynamodb put-item \
        --table-name "$TABLE_NAME" \
        --region "$REGION" \
        --item "$JSON_PAYLOAD"

    echo "Item $COUNT inserted successfully!"
}

function add-item-from-json() {
    local JSON_FILE="./json/item.json"
    awslocal dynamodb put-item \
        --table-name "$TABLE_NAME" \
        --region "$REGION" \
        --item file://$JSON_FILE
}

function populate_db() {
    local COUNT=$1
    for INDEX in $(seq 1 $COUNT); do
        add-item $INDEX
    done

    echo "Finished populating $TABLE_NAME with $COUNT random items."
}

function describe-table() {
    awslocal dynamodb describe-table --table-name $TABLE_NAME
}

function list-tables() {
    awslocal dynamodb list-tables
}

function delete-table() {
    awslocal dynamodb delete-table --table-name $TABLE_NAME
}

function update-item() {
    # use update-item to update an existing item

    KEY_JSON_PAYLOAD=$(jq -n \
        --arg user_id "user_2" \
        --arg timestamp "1740641114" \
        '{
        user_id: {S: $user_id},
        timestamp: {N: ($timestamp | tostring)}
    }')

    EXPRESSION_ATTRIBUTE_NAMES_JSON_PAYLOAD=$(jq -n \
        '{
        "#content": "content"
    }')

    EXPRESSION_ATTRIBUTE_VALUES_JSON_PAYLOAD=$(jq -n \
        --arg content "content_1_updated by me again" \
        '{
        ":content": {S: $content}
    }')

    # Run the AWS CLI command with the properly formatted JSON
    awslocal dynamodb update-item \
        --table-name "$TABLE_NAME" \
        --region "$REGION" \
        --key "$KEY_JSON_PAYLOAD" \
        --update-expression "SET #content = :content" \
        --expression-attribute-names "$EXPRESSION_ATTRIBUTE_NAMES_JSON_PAYLOAD" \
        --expression-attribute-values "$EXPRESSION_ATTRIBUTE_VALUES_JSON_PAYLOAD"
}

function update-item-from-json() {
    local KEY_FILE="./json/key.json"
    local EXPRESSION_ATTRIBUTE_NAMES_FILE="./json/attribute-names.json"
    local EXPRESSION_ATTRIBUTE_VALUES_FILE="./json/attribute-values.json"
    awslocal dynamodb update-item \
        --table-name "$TABLE_NAME" \
        --region "$REGION" \
        --key file://$KEY_FILE \
        --update-expression "SET #var_title = :t" \
        --expression-attribute-names file://$EXPRESSION_ATTRIBUTE_NAMES_FILE \
        --expression-attribute-values file://$EXPRESSION_ATTRIBUTE_VALUES_FILE

}

function delete-item() {
    awslocal dynamodb delete-item \
        --table-name "$TABLE_NAME" \
        --region "$REGION" \
        --key '{
        "user_id": {"S": "user_2"},
        "timestamp": {"N": "1740641114"}
    }'
}

function batch-write-from-json() {
    local JSON_FILE="./json/batch-write.json"
    # by not specificing the table name here, but in the file, we can use the same file for multiple tables
    awslocal dynamodb batch-write-item \
        --request-items file://$JSON_FILE
}

function get-item() {
    awslocal dynamodb get-item \
        --table-name "$TABLE_NAME" \
        --region "$REGION" \
        --key '{
        "user_id": {"S": "user_3"},
        "timestamp": {"N": "1740641116"}
    }'
}

function query-items() {
    EXPRESSION_ATTRIBUTE_NAMES='{
        "#var_timestamp": "timestamp"
    }'
    EXPRESSION_ATTRIBUTE_VALUES='{
        ":uid": {"S": "user_3"},
        ":t": {"N": "5"}
    }'
    KEY_CONDITION_EXPRESSION="user_id = :uid AND #var_timestamp > :t"
    awslocal dynamodb query \
        --table-name "$TABLE_NAME" \
        --region "$REGION" \
        --key-condition-expression "$KEY_CONDITION_EXPRESSION" \
        --expression-attribute-values "$EXPRESSION_ATTRIBUTE_VALUES" \
        --expression-attribute-names "$EXPRESSION_ATTRIBUTE_NAMES"
}

function list-items-to-json() {
    awslocal dynamodb scan \
        --table-name "$TABLE_NAME" \
        --region "$REGION" \
        --output json >./json/export_items.json
}

create-db
populate_db 10

# describe-table
# list-tables
# update-item
# add-item-from-json
# update-item-from-json
# delete-item
# batch-write-from-json
# get-item
# query-items
# list-items-to-json