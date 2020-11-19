# Serverless Google Cloud Functions Golang Template

This template project is designed to be used as a starting point for a Google Cloud Functions project using the Golang runtime and the Serverless Framework.

## Requirements

- You have the [Serverless Framework](https://www.serverless.com/framework/docs/getting-started/) installed.
- You have a project already created and configured in Google Cloud. You can follow [this guide](https://www.serverless.com/framework/docs/providers/google/guide/credentials/) to make sure its setup to work with Severless.
- You've setup your overall environment to work with GCP and the Serverless Framework. You should follow [these guides](https://www.serverless.com/framework/docs/providers/google/guide/intro/) if not.

## Project structure

The root directory contains a folder for each of your microservices (i.e. Go package).

The `go.mod` file also resides in the root directory.

## Start a new project from the template

1. Clone the template repo into a new local project folder:

<pre>
git clone https://github.com/cgossain/serverless-google-cloud-functions-golang-template.git <b>my-gcp-project-name</b>
</pre>

2. Update `go.mod` in the root directory with your project name. For example:

<pre>
module github.com/<b>my-gcp-project-name</b>

go 1.13
</pre>

## Create a new micoservice/package

Create a directory (i.e. package) for each logical microservice you intend to deploy. Each microservice could be made up of a single or several cloud functions.

### TL;DR:

1. From the root directory, make a copy of the `templateservice` directory and rename it to match your microservice/package name:

<pre>
cp -R templateservice <b>mynewservice</b>
</pre>

2. Navigate to the new directory and install the Google Cloud Functions Provider Plugin:

<pre>
cd <b>mynewservice</b> && serverless plugin install --name serverless-google-cloudfunctions
</pre>

3. Update the package name in both `fn.go` and `fn_test.go` to match your microservice/package name:

<pre>
package <b>mynewservice</b>

...
</pre>

4. Open `serverless.yml` and update the configuration (i.e. service name, GCP project name, GCP credentials keyfile, etc.):

<pre>
service: <b>mynewservice</b>

provider:
  name: google
  runtime: go113
  project: <b>my-gcp-project-name</b>
  credentials: <b>~/.gcloud/keyfile.json</b> # https://www.serverless.com/framework/docs/providers/google/guide/credentials/

plugins:
  - serverless-google-cloudfunctions

package:
  exclude:
    - .gitignore
    - .git/**

functions:
  hello:
    handler: Hello
    events:
      - http: path # https://www.serverless.com/framework/docs/providers/google/events/http#http-events

...
</pre>

### Additional info

Take a look at [this guide](https://cloud.google.com/functions/docs/writing#structuring_source_code) for ideas on how to structure your source code for different scenarios:

## Deploy

Run the following command from within your microservice/package directory to build and deploy all functions:

<pre>
cd <b>mynewservice</b> && serverless deploy
</pre>

## Remove Deployment

Run the following command from within your microservice/package directory to remove the deployment of all functions:

<pre>
cd <b>mynewservice</b> && serverless remove
</pre>

## References

1. [Serverless GCP Golang Example](https://github.com/serverless/examples/tree/master/google-golang-simple-http-endpoint)
