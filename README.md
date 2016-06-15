# sparkle-aws-demo

## Using this code (On AWS)
* Clone this repo
* Install Ruby 2.1.x
* `cd sparkle-aws-demo`
* `bundle install`
* Configure your credentials, see [Credentials / Config](#credentials--config)
* `sfn create demoapp --file demoapp --defaults`
* Should create a working cloudformation stack

## Using this code (Locally)
* Clone this repo
* Install Ruby 2.1
* Install ChefDK
* `cd sparkle-aws-demo`
* `bundle install`
* `kitchen create demoapp`
* `kitchen converge demoapp`
* `kitchen login demoapp`
* OR `kitchen test`

## Credentials / Config

You need to set the following environment variables with the respective keys for AWS, if you want to use another cloud, look at .sfn in this repo:
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_REGION # This needs to be us-east-1, otherwise you need to change the az's in sparkleformation/demoapp.rb

You need to create the following manually:
* The keypair 'demoapp' must exist in AWS, if you care about SSH'ing into it.

## Destroy
* `sfn destroy demoapp`
* OR
* `kitchen destroy demoapp`

## Security
* Does not use SSL
* Port 22 open to everyone (On AWS)
* No automatic OS updates

## Provides (AWS)
* Cloudformation stack
* An AWS ELB
* An AWS IAM Role (w/ instance profile)
* An AWS Security group allowing ssh & access from the ELB
* An AWS Launch Configuration
* An AWS Auto Scaling Group that brings up a minimum of 2 instances with all the above attached.
* A chef-zero deployment setup that deploys the a demo webapp
