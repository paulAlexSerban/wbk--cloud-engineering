#!/bin/bash

export $(grep -v '^#.*' .env | xargs)

echo 'Copy installed plugins to ./src'
cp -r ./wordpress/wp-content/themes/test-wordpress-project/plugins/* ./src