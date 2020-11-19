# Serverless Google Cloud Functions Golang Template

This template project is designed to be used as a starting point for a Google Cloud Functions project using the Golang runtime and the Serverless Framework.

## Requirements

- Install [Serverless Framework](https://www.serverless.com/framework/docs/getting-started/)
- Setup you serverless environment to work with GCP by working you way through the Serverless Framework [GCP guides](https://www.serverless.com/framework/docs/providers/google/guide/intro/)

## Usage

Create a new service for each logical microservice you intend to deploy.

Each microservice could be made up of a single or several cloud functions.

### Create a new service

Use the `serverless create` command to download the template into a new project folder:

<pre>
serverless create --template-url https://github.com/cgossain/serverless-google-cloud-functions-golang-template.git --path <b>mynewservice</b>
</pre>

### Configure the template

1. Navigate to the template directory and install the Google Cloud Functions Provider Plugin:

<pre>
cd <b>mynewservice</b> && serverless plugin install --name serverless-google-cloudfunctions
</pre>

2. Update `go.mod` with your module name. For example:

<pre>
module github.com/<b>my-gcp-project-name</b>/<b>mynewservice</b>

go 1.13
</pre>

3. Change the root package name in both `fn.go` adn `fn_test.go` to match you service name:

<pre>
package <b>mynewservice</b>

...
</pre>

4. Open `serverless.yml` and update the configuration (i.e. service name, provider details, etc.):

<pre>
service: <b>mynewservice</b>

provider:
  name: google
  runtime: go113
  project: <b>my-gcp-project-name</b>
  credentials: ~/.gcloud/keyfile.json # https://www.serverless.com/framework/docs/providers/google/guide/credentials/

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

5. Take a look at [this guide](https://cloud.google.com/functions/docs/writing#structuring_source_code) for ideas on how to structure your source code for different scenarios:

## Deploy

Run the following command from your service directory to build and deploy all functions:

<pre>
cd <b>mynewservice</b> && serverless deploy
</pre>

## Remove Deployment

Run the following command from your service directory to remove the deployment of all functions:

<pre>
cd <b>mynewservice</b> && serverless remove
</pre>

## References

1. [Serverless GCP Golang Example](https://github.com/serverless/examples/tree/master/google-golang-simple-http-endpoint)
