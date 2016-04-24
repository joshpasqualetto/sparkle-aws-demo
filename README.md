# sparkle-aws-demo

## Assumptions
* Ruby 2.1.x is installed
* You have credentials configured, See credentials & config below

## Credentials / Config

You need to set the following environment variables with the respective keys for AWS, if you want to use another cloud, look at .sfn in this repo:
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_REGION # This needs to be us-east-1, otherwise you need to change the azs in sparkleformation/demoapp.rb

You need to create the following manually:
* The keypair 'demoapp' must exist in AWS

## Security

* Does not use SSL
* Port 22 open to everyone 

## Provides
* Cloudformation stack
* An AWS ELB
* An AWS IAM Role (w/ instance profile)
* An AWS Security group allowing ssh & access from the ELB
* An AWS Launch Configuration
* An AWS Auto Scaling Group that brings up a minimum of 2 instances with all the above attached.
* A chef-zero deployment setup that deploys the bcus demo app proxied by nginx
