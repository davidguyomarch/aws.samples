#!/bin/bash

PROFILE="default"
SERVERLESS_STACK_NAME="hello-app-api-prod"

usage()
{
cat <<-EOF
USAGE: usage [OPTIONS] [TEXT]

 OPTIONS

   -h | --help | -?      Display this help message

   -p | --profile        Define the aws profile of your .aws/config file you want to use.
                         default: default

   -n | --stackname      Define the name of the stack
                         default: ServerlessDemo
EOF
  return
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h | --help | -\?)
      shift # past argument
      usage
      exit
      ;;
    -p | --profile)
      PROFILE="$2"
      shift # past argument
      shift # past value
      ;;
    -n | --stackname)
      SERVERLESS_STACK_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      echo "ERROR: unknown parameter \"$POSITIONAL\""
      usage
      exit 1
      ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


UserPoolId=$(aws cloudformation describe-stacks \
    --stack-name $SERVERLESS_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`CognitoUserPoolName`].OutputValue' \
    --output text \
    --profile $PROFILE)
UserPoolArn=$(aws cloudformation describe-stacks \
    --stack-name $SERVERLESS_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`CognitoUserPoolArn`].OutputValue' \
    --output text \
    --profile $PROFILE)
IdentityPoolId=$(aws cloudformation describe-stacks \
    --stack-name $SERVERLESS_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`CognitoIdentityPoolId`].OutputValue' \
    --output text \
    --profile $PROFILE)
ClientId=$(aws cloudformation describe-stacks \
    --stack-name $SERVERLESS_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`CognitoIdentityPoolClientId`].OutputValue' \
    --output text \
    --profile $PROFILE)

HomePageURL=$(aws cloudformation describe-stacks \
    --stack-name $SERVERLESS_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`HomePageURL`].OutputValue' \
    --output text \
    --profile $PROFILE)

ServiceEndpoint=$(aws cloudformation describe-stacks \
    --stack-name $SERVERLESS_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`ServiceEndpoint`].OutputValue' \
    --output text \
    --profile $PROFILE)

Region=$(aws configure get region --profile $PROFILE)

(set -x; apig-test \
      --username='david' \
      --password='Azerty1234!' \
      --user-pool-id="$UserPoolId" \
      --app-client-id="$ClientId" \
      --cognito-region="$Region" \
      --identity-pool-id="$IdentityPoolId" \
      --invoke-url="$ServiceEndpoint" \
      --api-gateway-region="$Region" \
      --path-template='/notes/count' \
      --method='GET' \
  )

  # --params='{ "hello": "david" }' \
