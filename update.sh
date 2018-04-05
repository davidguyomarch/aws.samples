#!/bin/bash


aws cloudformation update-stack \
  --stack-name BpceMarketplace    \
  --template-body file://./resources.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
      ParameterKey=KeyName,ParameterValue=david_eu_central_1

  # \
  # --profile hicham

  # \
  # --parameters \
  #     ParameterKey=KeyName,ParameterValue=david_eu_central_1
