# sparkle-aws-demo

## Assumptions
* Ruby 2.1.x is installed
* You have credentials configured, See credentials & config below



## Credentials / Config
You need to set the following environment variables with the respective keys for AWS, if you want to use another cloud, look at ~/.sfn:
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_REGION

You need to create the following manually:
* The keypair 'demoapp' must exist in AWS


## Issues
* Does not implement VPC
* Does not use cloudwatch to dynamically scale up and down
