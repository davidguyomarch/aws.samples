#!/bin/bash

# USING SAM

# aws cloudformation package \
#    --template-file resources.yaml \
#    --output-template-file serverless-output.yaml \
#    --s3-bucket vo-serverless-deploy-bucket
#
# aws cloudformation deploy \
#     --template-file serverless-output.yaml \
#     --stack-name serverless-test \
#     --capabilities CAPABILITY_NAMED_IAM

# USING SERVERLESS


PROFILE="default"
# BUCKET_NAME="vo-oab-bpce-marketplace-frontend-bucket"
STACK_NAME="ServerlessDemo"

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
      STACK_NAME="$2"
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


DynamoDBTableArn=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`DynamoDBTableArn`].OutputValue' \
    --output text \
    --profile $PROFILE)

serverless deploy --NoteDynamodbTableArn $DynamoDBTableArn

# arn:aws:execute-api:eu-central-1:392033229120:alvij63fw1/*/GET/hello
# DynamoDBTableArn=$(aws cloudformation describe-stacks \
#     --stack-name  hello-app-api-prod \
#     --query 'Stacks[0].Outputs[?OutputKey==`DynamoDBTableArn`].OutputValue' \
#     --output text \
#     --profile $PROFILE)
#
