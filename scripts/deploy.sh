#!/bin/bash

if [[ "$1" != "" ]]; then
    PROFILE_NAME="$1"
else
    echo ERROR: Failed to supply AWS CLI profile name
    exit 1
fi

if [[ "$2" != "" ]]; then
    S3BUCKET_NAME="$2"
else
    echo ERROR: Failed to supply S3 bucket name
    exit 1
fi

aws s3 sync _site "s3://$S3BUCKET_NAME" --profile $PROFILE_NAME --exclude '*.html' --cache-control 'max-age=31536000,public'
aws s3 sync _site "s3://$S3BUCKET_NAME" --profile $PROFILE_NAME --exclude '*' --include '*.html' --cache-control 'max-age=0,public'
