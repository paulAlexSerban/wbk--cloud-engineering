#!/bin/bash

export $(grep -v '^#.*' .env | xargs)

echo 'Copy required files'
cp -rv ./src/required/* ./wordpress/wp-content/themes/"${PROJECT_NAME}"
echo 
echo 'Copy template files'
cp -rv ./src/templates/* ./wordpress/wp-content/themes/"${PROJECT_NAME}"
echo
echo 'Copy Must Use Plugins'
cp -rv ./src/mu-plugins ./wordpress/wp-content/themes/"${PROJECT_NAME}"
echo 
echo 'Copy Includes'
cp -rv ./src/includes ./wordpress/wp-content/themes/"${PROJECT_NAME}"
echo 
echo 'Copy Plugins'
cp -rv ./src/plugins ./wordpress/wp-content/themes/"${PROJECT_NAME}"
echo 
echo 'Copy Uploads'
cp -rv ./src/uploads ./wordpress/wp-content/themes/${PROJECT_NAME}