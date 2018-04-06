#!/bin/bash

profile=$1
BucketName="vo-oab-bpce-marketplace-frontend-bucket"
if [ $profile = "hicham" ]
then
  echo "Deploying Website in Hicham AWS Account"
  BucketName="oab-bpce-marketplace-frontend-bucket"
else
  echo "Deploying Website in VO AWS Account"
  profile="default"
fi

UserPoolId=$(aws cloudformation describe-stacks \
    --stack-name BpceMarketplace \
    --query 'Stacks[0].Outputs[?OutputKey==`CognitoUserPoolName`].OutputValue' \
    --output text)
UserPoolArn=$(aws cloudformation describe-stacks \
    --stack-name BpceMarketplace \
    --query 'Stacks[0].Outputs[?OutputKey==`CognitoUserPoolArn`].OutputValue' \
    --output text)
IdentityPoolId=$(aws cloudformation describe-stacks \
    --stack-name BpceMarketplace \
    --query 'Stacks[0].Outputs[?OutputKey==`CognitoIdentityPoolId`].OutputValue' \
    --output text)
ClientId=$(aws cloudformation describe-stacks \
    --stack-name BpceMarketplace \
    --query 'Stacks[0].Outputs[?OutputKey==`CognitoIdentityPoolClientId`].OutputValue' \
    --output text)

# echo "UserPoolId $UserPoolId"
# echo "UserPoolArn $UserPoolArn"
# echo "IdentityPoolId $IdentityPoolId"
# echo "ClientId $ClientId"

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
    }
};

export default aws_exports

EOF

npm run build
aws s3 sync ./dist/ s3://$BucketName --profile $profile
