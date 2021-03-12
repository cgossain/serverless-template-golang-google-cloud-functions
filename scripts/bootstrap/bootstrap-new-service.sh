#!/bin/bash

# This script makes a copy of the templateservice 
# $1 - the name of the first service to create
service_name=$1
service_name_hook="templateservice"

echo "-------------------------------------------------------------------------"
echo "creating \"$service_name\" from \"templateservice\""
echo "-------------------------------------------------------------------------"
cp -R templateservice $service_name

# Replace all occurences of the service name hook with the given project name
find ./$service_name -name "*" -type f -print | LC_ALL=C xargs sed -i '' -e "s:$service_name_hook:$service_name:g"

# Stage all the above changes
git add .

# Commit
git commit -m "Add $service_name"

echo "done"