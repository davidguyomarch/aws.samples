#!/bin/bash

PROFILE="default"
BUCKET_NAME="vo-oab-bpce-marketplace-frontend-bucket"
INFRA_STACK_NAME="ServerlessDemo"
SERVERLESS_STACK_NAME=" hello-app-api-prod"

usage()
{
cat <<-EOF
USAGE: usage [OPTIONS] [TEXT]

 OPTIONS

   -h | --help | -?      Display this help message

   -p | --profile        Define the aws profile of your .aws/config file you want to use.
                         default: default

   -s | --s3BucketName   Define the name of your s3bucket
                         default: oab-bpce-marketplace-frontend-bucket

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
    -s | --s3BucketName)
      BUCKET_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    -n | --stackname)
      INFRA_STACK_NAME="$2"
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
    --stack-name $INFRA_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`CognitoUserPoolName`].OutputValue' \
    --output text \
    --profile $PROFILE)
UserPoolArn=$(aws cloudformation describe-stacks \
    --stack-name $INFRA_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`CognitoUserPoolArn`].OutputValue' \
    --output text \
    --profile $PROFILE)
IdentityPoolId=$(aws cloudformation describe-stacks \
    --stack-name $INFRA_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`CognitoIdentityPoolId`].OutputValue' \
    --output text \
    --profile $PROFILE)
ClientId=$(aws cloudformation describe-stacks \
    --stack-name $INFRA_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`CognitoIdentityPoolClientId`].OutputValue' \
    --output text \
    --profile $PROFILE)

HomePageURL=$(aws cloudformation describe-stacks \
    --stack-name $INFRA_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`HomePageURL`].OutputValue' \
    --output text \
    --profile $PROFILE)

ServiceEndpoint=$(aws cloudformation describe-stacks \
    --stack-name $SERVERLESS_STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`ServiceEndpoint`].OutputValue' \
    --output text \
    --profile $PROFILE)

cat > ./src/aws-exports.js <<EOF

const aws_exports = {
    Auth: {
    // REQUIRED - Amazon Cognito Identity Pool ID
        identityPoolId: '$IdentityPoolId',
    // REQUIRED - Amazon Cognito Region
        region: 'eu-central-1',
    // OPTIONAL - Amazon Cognito User Pool ID
        userPoolId: '$UserPoolId',
    // OPTIONAL - Amazon Cognito Web Client ID (26-char alphanumeric string)
        userPoolWebClientId: '$ClientId',
    // OPTIONAL - Enforce user authentication prior to accessing AWS resources or not
        mandatorySignIn: false,
    },
    API: {
      endpoints: [
          {
              name: "my-api",
              endpoint: "$ServiceEndpoint"
          }
      ]
  }
};

export default aws_exports

EOF

npm run build
aws s3 sync ./dist/ s3://$BUCKET_NAME --profile $PROFILE

echo Your website is now available on $HomePageURL
