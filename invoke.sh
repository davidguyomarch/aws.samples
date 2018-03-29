#!/bin/sh

restapiId=ms6b1brd67
region=eu-central-1
stageName=prod

wget "https://$restapiId.execute-api.$region.amazonaws.com/$stageName"
