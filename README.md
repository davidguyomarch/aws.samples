# WebSite using Vue-js, a serverless backend et cognito auth.

## Installation

To create the needed resources, just execute the create script. You will need an iam account with administration-like rights.
default will use your default profile in .aws/config

```bash
$ ./create.sh
```

Check for available options by calling the script with -h option

```bash
$ ./create.sh -h
USAGE: usage [OPTIONS] [TEXT]

 OPTIONS

   -h | --help | -?      Display this help message

   -p | --profile        Define the aws profile of your .aws/config file you want to use.
                         default: default

   -s | --s3BucketName   Define the name of your s3bucket
                         default: oab-bpce-marketplace-frontend-bucket

   -n | --stackname      Define the name of the stack
                         default: ServerlessDemo
```

To deploy the website to the newly created s3 bucket, just use

```bash
$ cd ./webapp
$ ./deploy_website.sh
```

Check for available options by calling the script with -h option

```bash
$ ./deploy_website.sh -h
USAGE: usage [OPTIONS] [TEXT]

 OPTIONS

   -h | --help | -?      Display this help message

   -p | --profile        Define the aws profile of your .aws/config file you want to use.
                         default: default

   -s | --s3BucketName   Define the name of your s3bucket
                         default: oab-bpce-marketplace-frontend-bucket

   -n | --stackname      Define the name of the stack
                         default: ServerlessDemo
```

During your project life, you can update the stack if you change anything in the template by using

```bash
$ ./update.sh
```
