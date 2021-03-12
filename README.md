# Serverless Google Cloud Functions Golang Template

This template project is designed to be used as a starting point for a Google Cloud Functions project using the Golang runtime and the Serverless Framework.

## Prerequisites

- Install the [Serverless Framework](https://www.serverless.com/framework/docs/getting-started/)
- Install the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- Follow [this guide](https://www.serverless.com/framework/docs/providers/google/guide/credentials/) to make sure your GCP project is setup to work with Severless

## Project structure

A few notes about the project structure:

- The root directory contains a `package.json` file which defines dev dependencies needed to deploy functions using the Serverless Framework
- This template assumes that each logical microservice will be contained within its own package/directory and deployed separately using its own `serverless.yml` definition
- Each package/directory could contain one or more cloud functions, and has its own `go.mod` file to manage dependencies by microservice
- This template includes a `.env` file which you can use to put environment variables used for local development as well as a `cmd` directory that contains a `main.go` file that starts up a server that you can use to test your functions locally

<pre>
.
├── ...
├── microservice1
│   └── cmd
│       └── main.go
│   └── .env
│   └── fn_test.go
│   └── fn.go
│   └── go.mod
│   └── serverless.yml
│   └── ...
├── microservice2
│   └── cmd
│       └── main.go
│   └── .env
│   └── fn_test.go
│   └── fn.go
│   └── go.mod
│   └── serverless.yml
│   └── ...
├── package.json
├── ...
</pre>

Take a look at [this guide](https://cloud.google.com/functions/docs/writing#structuring_source_code) to learn more about structuring your code.

## Create a new project using the included scripts

### 1. Bootstrap new project

Copy the `bootstrap-new-project.sh` script (located under `/scripts/bootstrap/` of this repo) to the directory where you want to create your project, and run it.

```
Arguments:
// $1 - Your github username (i.e. `cgossain`)
// $2 - The name of your new project

./bootstrap-new-project.sh <mygithubusername> <myprojectname>
```

### 2. Review the `serverless.yml` file of the templateservice

Navigate to the microservice/package directory of the templateservice, and verify the following in the `serverless.yml` file:
1. Make sure the `provider.project` field matches the project ID of your GCP project
2. Make sure the `provider.credentials` field matches your json keyfile

<pre>
service: templateservice
useDotenv: true

provider:
  name: google
  runtime: go113
  project: <b>gcp-project-id</b> # defaults to the project name
  credentials: <b>~/.gcloud/keyfile.json</b> # https://www.serverless.com/framework/docs/providers/google/guide/credentials/

...
</pre>

### 3. Create a new microservice/package

Run the `/scripts/bootstrap/bootstrap-new-service.sh` script from your projects' root directory to create a new microservice package from the templateservice.

```
./scripts/bootstrap/bootstrap-new-service.sh <mynewservicename>
```

## Local testing

For each microservice/package directory that you want to test, modify the server defined in `cmd/main.go` with routes to your functions (and provide any test payloads needed), then run the file:

```
go run main.go
```

Now call your functions.

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

## Access control (making functions public)

Google makes your functions private by default. If you're deploying an HTTP triggered function you'll likely want to have it be publicly accessible. 

At this time the Serverless Framework does provide a way to do this via the `serverless.yml` file, but we can work around it in a few way.

### Option 1 (update via script):

This project includes a script that works with your `serverless.yml` file to make your functions private or public. 

First add the `allowUnauthenticated: true` key to each of the functions you'd like to make public in your `serverless.yml` file. This is a custom key that the script looks for.

<pre>
...

functions:
  hello:
    handler: Hello
    events:
      - http: path # https://www.serverless.com/framework/docs/providers/google/events/http#http-events
    <b>allowUnauthenticated: true</b> # unofficial flag that ties into the post-deploy script

...
</pre>

Then run the following script from within your microservice/package directory:

```
../scripts/deploy/sls-update-allow-unauthenticated.sh
```

Alternatively, to have the script run automatically after every `serverless deploy`, uncomment the `custom.scripts.commands.hooks` section in the `serverless.yml` file:

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

### Option 2: Update via plugin commands

The included `serverless.yml` file uses the `serverless-plugin-scripts` plugin and defines 2 commands.

To make a function public, run the following from within your microservice/package directory:

```
sls mkfunc-pub --function=hello
```

To make a function private, run the following from within your microservice/package directory:

```
sls mkfunc-pvt --function=hello
```

### Update manually

This can be done either through the console or the gcloud cli [as detailed here](https://cloud.google.com/run/docs/authenticating/public).


## Appendix A: Create a new project manually

This section is included for completeness sake, but you should probably just use the above scripts instead.

1. Clone the template repo into a new local project folder:

<pre>
git clone https://github.com/cgossain/serverless-google-cloud-functions-golang-template.git <b>my-gcp-project-name</b>
</pre>

2. Update `go.mod` in the root directory with your module path. For example:

<pre>
module github.com/my-github-username/my-gcp-project-name

go 1.13
</pre>

3. From the root directory, make a copy of the `templateservice` directory and rename it to match your microservice/package name:

<pre>
cp -R templateservice <b>mynewservice</b>
</pre>

4. Update the package name in both `fn.go` and `fn_test.go` to match your microservice/package name:

<pre>
package <b>mynewservice</b>

...
</pre>

5. Open `serverless.yml` and update the configuration (i.e. service name, GCP project name, GCP credentials keyfile, etc.):

<pre>
service: <b>mynewservice</b>
useDotenv: true

provider:
  name: google
  runtime: go113
  project: <b>gcp-project-id</b>
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

6. Install the serverless plugin dependencies (specified in `package.json`):

<pre>
// Run this from the root of the project directory
npm install
</pre>

## References

1. [Serverless GCP Golang Example](https://github.com/serverless/examples/tree/master/google-golang-simple-http-endpoint)
2. [Inspiration for Script Workaround](https://github.com/serverless/serverless-google-cloudfunctions/issues/205#issuecomment-658759740)
