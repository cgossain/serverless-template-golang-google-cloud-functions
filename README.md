# Serverless Google Cloud Functions Golang Template

This template project is designed to be used as a starting point for a Google Cloud Functions project using the Golang runtime and the Serverless Framework.

## Prerequisites

- Install the [Serverless Framework](https://www.serverless.com/framework/docs/getting-started/)
- Install the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install), and then run `gcloud auth login` to authenticate
- Create and configure a project in Google Cloud Console. You can follow [this guide](https://www.serverless.com/framework/docs/providers/google/guide/credentials/) to make sure its setup to work with Severless.

## Project structure

The root directory contains a folder for each microservice/package.

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

2. Update the package name in both `fn.go` and `fn_test.go` to match your microservice/package name:

<pre>
package <b>mynewservice</b>

...
</pre>

3. Open `serverless.yml` and update the configuration (i.e. service name, GCP project name, GCP credentials keyfile, etc.):

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
    allowUnauthenticated: true # unofficial flag that ties into the post-deploy script

...
</pre>

4. Install the serverless plugin dependencies (specified in `package.json`):

<pre>
npm install
</pre>

### Additional info

Take a look at [this guide](https://cloud.google.com/functions/docs/writing#structuring_source_code) for ideas on how to structure your source code for different scenarios:

## Deploy

Run the following command from within your microservice/package directory to build and deploy all functions:

<pre>
cd <b>mynewservice</b> && serverless deploy
</pre>

## Remove deployment

Run the following command from within your microservice/package directory to remove the deployment of all functions:

<pre>
cd <b>mynewservice</b> && serverless remove
</pre>

## Access control (public vs. private functions)

If you're deploying an HTTP triggered function you'll most likely want to have them be publicly accessible and google seems to make them private by default.

At this time it appears the `serverless-google-cloudfunctions` plugin does provide a way to make functions public in the `serverless.yml` file, so until this is supported by the plugin we can work around it in a few ways.

### Update manually

This can be done either through the console or the gcloud cli [as detailed here](https://cloud.google.com/run/docs/authenticating/public).

### Update via plugin commands

The included `serverless.yml` file uses the `serverless-plugin-scripts` plugin and defines 2 commands.

To make a function public, run the following from within your microservice/package directory:

```
npx sls mkfunc-pub --function=hello
```

To make a function private, run the following from within your microservice/package directory:

```
npx sls mkfunc-pvt --function=hello
```

### Update via script

This project includes a script that can automate the whole update process.

It works by running through all the functions defined in `serverless.yml` then sorting them as public or private (by checking for the presence of the `allowUnauthenticated: true` parameter within each function definition), then finally runs either `mkfunc-pub` or `mkfunc-pvt` for each function.

To run the script manually, run the following from within your microservice/package directory:

```
../scripts/sls-update-allow-unauthenticated.sh
```

To have the script run automatically after every serverless deploy, uncomment the `custom.scripts.commands.hooks` section in the `serverless.yml` file:

<pre>
...

custom:
  scripts:
    commands:
      ...
    <b>
    hooks:
      "after:deploy:deploy": ../scripts/sls-update-allow-unauthenticated.sh
    </b>
</pre>

_Note: Permissions don't actually need to be updated on each deploy which is why the post-deploy hook is commented out by default in this project. It should be sufficient to just manually run the script after each deploy that includes a new function of if you change the `allowUnauthenticated` value within a function definition._

## References

1. [Serverless GCP Golang Example](https://github.com/serverless/examples/tree/master/google-golang-simple-http-endpoint)
2. [Inspiration for Script Workaround](https://github.com/serverless/serverless-google-cloudfunctions/issues/205#issuecomment-658759740)
