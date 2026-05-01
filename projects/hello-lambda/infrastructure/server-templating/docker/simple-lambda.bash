#!/bin/bash
# makes sure the folder containing the script will be the root folder
cd "$(dirname "$0")" || exit

APP_NAME=""
# inspired from maven phases (https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)
PHASE=""


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

function compile-lambda() {
    echo "[ 🏗️ 🐳 ] --- compile the lambda source code"
    docker build -f ../../../backend/functions/${APP_NAME}/Dockerfile \
        -t ${APP_NAME}-builder \
        ../../../backend/functions/${APP_NAME}
}

function package-lambda() {
    echo "[ 🚀 ] --- package the lambda in distributable format"
    if [ ! -d "../../../backend/functions/${APP_NAME}/dist" ]; then
        mkdir ../../../backend/functions/${APP_NAME}/dist
    fi

    docker run --rm -v $(pwd)/../../../backend/functions/${APP_NAME}/dist:/package ${APP_NAME}-builder
}

function build() {
    compile-lambda
    package-lambda
}

$PHASE && echo "[ ✅ ] --- done building lambda package" || echo "[ 🚫 ] --- failed building lambda package"