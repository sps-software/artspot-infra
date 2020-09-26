{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "OnlyCloudfrontReadAccess",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${originAccessIdentityArn}"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${bucketName}/*"
        }
    ]
}