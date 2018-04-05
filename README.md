# WebSite using Vue-js, a serverless backend et cognito auth.

## Installation

To create the needed resources, just execute the create script. You will need an iam account with administration-like rights.
default will use your default profile in .aws/config

```bash
$ ./create.sh default
```

To deploy the website to the newly created s3 bucket, just use

```bash
$ ./deploy_website.sh default
```
