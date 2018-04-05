#!/bin/bash

profile=$1
BucketName="vo-oab-bpce-marketplace-frontend-bucket"
if [ $profile = "hicham" ]
then
  echo "Creating Stack in Hicham AWS Account"
  BucketName="oab-bpce-marketplace-frontend-bucket"
else
  echo "Creating Stack in VO AWS Account"
  profile="default"
fi
aws cloudformation create-stack \
  --stack-name BpceMarketplace \
  --template-body file://./resources.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
      ParameterKey=BucketName,ParameterValue=$BucketName \
      ParameterKey=AppName,ParameterValue=BpceMarketplace \
  --profile $profile
