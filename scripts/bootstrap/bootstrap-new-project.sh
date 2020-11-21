#!/bin/bash

# This script clones the template repository to a new folder matching the given project name.
# $1 - the name of the new project
# $2 - the name of the first service to create (optional)
project_name=$1
project_name_hook="my-gcp-project-name"

service_name=$2

echo "-------------------------------------------------------------------------"
echo "configuration"
echo "-------------------------------------------------------------------------"
echo "project name: $project_name"
if [[ ! -z "$service_name" ]]; then
    echo "first service name: $service_name"
else
    echo "first service name: n/a"
fi
echo "-------------------------------------------------------------------------"

echo "-------------------------------------------------------------------------"
echo "cloning template"
echo "-------------------------------------------------------------------------"
# Clone the template into the project directory
git clone https://github.com/cgossain/serverless-google-cloud-functions-golang-template.git $project_name

# Replace all occurences of the project name hook with the given project name
find ./$project_name ! -path "*/node_modules/*" ! -path "*/scripts/*" -name "*" -type f -print | LC_ALL=C xargs sed -i '' -e "s:$project_name_hook:$project_name:g"

echo "done"

echo "-------------------------------------------------------------------------"
echo "installing serverless plugins"
echo "-------------------------------------------------------------------------"
# Run "npm install" from the project directory
find ./$project_name ! -path "*/node_modules/*" ! -path "*/scripts/*" -name "package.json" -execdir npm install \;

echo "done"

# Create an initial service if a value was provided
if [[ ! -z "$service_name" ]]; then
    # Run the "bootstrap-new-service.sh" scriptfrom the project directory
    find ./$project_name ! -path "*/node_modules/*" ! -path "*/scripts/*" -name "package.json" -execdir ./scripts/bootstrap/bootstrap-new-service.sh "$service_name" \;
fi
