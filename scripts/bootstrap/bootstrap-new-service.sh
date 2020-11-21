#!/bin/bash

# This script makes a copy of the templateservice 
# $1 - the name of the first service to create
service_name=$1
service_name_hook="templateservice"

cp -R templateservice $service_name

# Replace all occurences of the service name hook with the given project name
find ./$service_name -name "*" -type f -print | LC_ALL=C xargs sed -i '' -e "s:$service_name_hook:$service_name:g"
