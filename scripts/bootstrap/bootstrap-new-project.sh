#!/bin/bash

# This creates a new project from the template repository
# $1 - your github username
# $2 - the name of the new project
# $3 - the name of the first service to create (optional)
github_username=$1
github_username_hook="my-github-username"

project_name=$2
project_name_hook="my-gcp-project-name"

service_name=$3

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
git clone --depth 1 https://github.com/cgossain/serverless-google-cloud-functions-golang-template.git $project_name

# Remove the `origin` remote from the cloned repository
git --git-dir="$project_name/.git" remote remove origin

# Replace all occurences of the `github_username_hook` with the actual github username
find ./$project_name ! -path "*/node_modules/*" ! -path "*/scripts/*" -name "*" -type f -print | LC_ALL=C xargs sed -i '' -e "s:$github_username_hook:$github_username:g"

# Replace all occurences of the `project_name_hook` with the actual project name
find ./$project_name ! -path "*/node_modules/*" ! -path "*/scripts/*" -name "*" -type f -print | LC_ALL=C xargs sed -i '' -e "s:$project_name_hook:$project_name:g"

echo "done"

echo "-------------------------------------------------------------------------"
echo "installing serverless plugins"
echo "-------------------------------------------------------------------------"
# Run "npm install" from the project directory
find ./$project_name ! -path "*/node_modules/*" ! -path "*/scripts/*" -name "package.json" -execdir npm install \;

echo "done"

echo "-------------------------------------------------------------------------"
echo "commiting changes"
echo "-------------------------------------------------------------------------"
# Stage all the above changes
find ./$project_name ! -path "*/node_modules/*" ! -path "*/scripts/*" -name "package.json" -execdir git add . \;

# Rename latest(i.e. `--depth 1`)/initial commit
git --git-dir="$project_name/.git" commit --amend -m "Initial commit"

echo "done"

# Create the first service if a value was provided
if [[ ! -z "$service_name" ]]; then
    # Run the "bootstrap-new-service.sh" scriptfrom the project directory
    find ./$project_name ! -path "*/node_modules/*" ! -path "*/scripts/*" -name "package.json" -execdir ./scripts/bootstrap/bootstrap-new-service.sh "$service_name" \;
fi