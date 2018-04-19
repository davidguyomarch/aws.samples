# Demo of a Serverless app on AWS.

## Purpose

This project is a demo app to showcase the capabilities of AWS for serverless application, based on
- a Serverless backend
  -	a API REST declared in [API Gateway](https://aws.amazon.com/api-gateway),
  -	Functions As a Service are based on [AWS Lambda](https://aws.amazon.com/lambda/features/), developed in [NodeJS 8](https://nodejs.org/en/)
  -	Data are stored in a [DynamoDB](https://aws.amazon.com/dynamodb/) table
  - Users are stored in a [Cognito User Pool](https://aws.amazon.com/cognito/)
  - Backend resources (API Gateway resources) are protected by [Cognito Federated Identity](https://aws.amazon.com/cognito/)

- a Front end app is a One Page App developed in [Vue.js](https://vuejs.org/).
  -	The app is accessible for authenticated users.
  - We use [AWS Amplify](https://aws.github.io/aws-amplify/) to access AWS resources. The Amplify library greatly simplifies the use of AWS Serverless resources: Authentication through Cognito and APi Gateway secured access.

- Deployment is automated through scripts using [serverless.com](https://serverless.com/) for the backend, and [AWS CloudFormation](https://aws.amazon.com/cloudformation) to create the [S3 bucket](https://aws.amazon.com/s3) to host the frontend.

This application has no purpose for now. It is just a demo app to show the articulation of a DevOps developed software with AWS.

We compiled some useful [lessons-learned and pro-tips](./doc/lessons_learned.md).

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
