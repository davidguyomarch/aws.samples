#!/bin/bash

profile=$1
BucketName="vo-oab-bpce-marketplace-frontend-bucket"
if [ $profile = "hicham" ]
then
  echo "Updating Stack in Hicham AWS Account"
  BucketName="oab-bpce-marketplace-frontend-bucket"
else
  echo "Updating Stack in VO AWS Account"
  profile="default"
fi

aws cloudformation update-stack \
  --stack-name BpceMarketplace \
  --template-body file://./resources.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
      ParameterKey=BucketName,ParameterValue=$BucketName \
      ParameterKey=AppName,ParameterValue=BpceMarketplace \
  --profile $profile
