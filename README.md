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

You need to create the following manually:
* You should probably create a test/throwaway keypair in AWS, then set the environment variable DEMOAPP_KEY_NAME to that. It's used in sparkleformation/demoapp.rb to set the key in the launch config. See below.

You need to set the following environment variables with the respective keys for AWS, if you want to use another cloud, look at .sfn in this repo:
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_REGION # This needs to be us-east-1, otherwise you need to change the az's in sparkleformation/demoapp.rb
* DEMOAPP_KEY_PATH # Needs to be the path to the demoapp private key
* DEMOAPP_KEY_NAME # The name of your keypair in AWS

## Destroy
* `sfn destroy demoapp`
* OR
* `kitchen destroy demoapp`

## Tests

### ServerSpec
The provided sparkleformation template is infused with some ServerSpec magic to run ServerSpec tests against created resources, This happens automatically on creation or update of a resource.
But you can execute them manually with this command:

`bundle exec sfn serverspec demoapp -f demoapp`

### Developmental tests (Rubocop, Foodcritic, Test kitchen)
The provided tests useful during development are rubocop, food critic and test kitchen. If you would like to use test kitchen please see [Using this code (Locally)](#Using-this-code-(Locally))
rubocop provides ruby lint checking and foodcritic applies best practice tests against the single cookbook we have.

`bundle exec rubocop -D --format offenses --format progress --fail-level W` will run rubocops in the repo
`bundle exec foodcritic chef/cookbooks` will run your foodcritic ests
`rake test` will run rubocop, foodcritic AND serverspec tests, however you need to ensure demoapp stack is up and running for it to pass.
`bundle exec guard` Runs tests while you work

## Security
* Does not use SSL
* Port 22 open to everyone (On AWS)
* Does run automatic OS updates (unattended-upgrades)

## Provides (AWS)
* Cloudformation stack
* An AWS ELB
* An AWS IAM Role (w/ instance profile)
* An AWS Security group allowing ssh & access from the ELB
* An AWS Launch Configuration
* An AWS Auto Scaling Group that brings up a minimum of 2 instances with all the above attached.
* A chef-zero deployment setup that deploys the a demo webapp
