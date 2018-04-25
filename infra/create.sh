#!/bin/bash


PROFILE="default"
BUCKET_NAME="oab-bpce-marketplace-frontend-bucket"
STACK_NAME="hello-client-prod"

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
                         default: hello-client-prod
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

echo "Creating Stack with $PROFILE AWS Profile"
aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://./resources.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
      ParameterKey=BucketName,ParameterValue=$BUCKET_NAME \
  --profile $PROFILE
