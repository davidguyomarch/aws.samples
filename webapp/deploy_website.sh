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

npm run build
aws s3 sync ./dist/ s3://$BucketName
