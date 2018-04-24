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
REGION="eu-central-1"
# BUCKET_NAME="vo-oab-bpce-marketplace-frontend-bucket"
# STACK_NAME="ServerlessDemo"

usage()
{
cat <<-EOF
USAGE: usage [OPTIONS] [TEXT]

 OPTIONS

   -h | --help | -?      Display this help message

   -p | --profile        Define the aws profile of your .aws/config file you want to use.
                         default: default

   -r | --region        AWS Region.
                         default: eu-central-1

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
    -r | --region)
      REGION="$2"
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

# DynamoDBTableArn=$(aws cloudformation describe-stacks \
#     --stack-name $STACK_NAME \
#     --query 'Stacks[0].Outputs[?OutputKey==`DynamoDBTableArn`].OutputValue' \
#     --output text \
#     --profile $PROFILE)

serverless deploy --region $REGION
