# WebSite using Vue-js, a serverless backend and cognito auth.

## Installation

The application is divided in 2 different parameters
- WebSite
- Backend

### Backend
To install the backend (serverless backend, using api gateway, lambda, cognito), just cd to the backend-api directory and execute the deploy.sh script.
You can check the options, by launching deploy.sh -h.

```bash
$ cd ./backend-api
$ ./deploy.sh --profile default
```

Under the hood, we rely on serverless for the description of the ressources.

### Website
To install the website (Vue.js app using Aws Amplify to access the REST API deployed on AWS), follow the 2-step procedure

1. Create an s3 bucket to host your website static files
2. Build the webapp and copy it into this bucket

To create the s3 bucket that will host your site, you can use the predefined CLoudformation stack in infra
Cd to infra, and launch the deploy.sh script.
You can check the options, by launching deploy.sh -h.

```bash
$ cd ./infra
$ ./deploy.sh --profile default
```

Go to the webapp directory and run deploy.sh, to automatically generate the config file, build the vue.js app and copy it to your previously created s3 bucket.
You can check the options, by launching deploy.sh -h.

```bash
$ cd ./webapp
$ ./deploy.sh --profile default
```
