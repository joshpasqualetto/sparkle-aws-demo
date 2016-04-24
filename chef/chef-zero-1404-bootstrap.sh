#!/bin/bash -v
export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y install wget build-essential git
wget --no-verbose --output-document /tmp/chef-omnibus.deb "https://packages.chef.io/stable/ubuntu/10.04/chef_12.9.38-1_amd64.deb"
dpkg --install /tmp/chef-omnibus.deb

mkdir -p /etc/chef
cd /root/
git clone https://github.com/sniperd/sparkle-aws-demo 
cd /root/sparkle-aws-demo

(
cat << 'EOP'
cookbook_path [
"/root/sparkle-aws-demo/chef/cookbooks"
]
log_level :info
log_location STDOUT
EOP
) > /root/sparkle-aws-demo/solo.rb

export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export HOME=/root

#/opt/chef/embedded/bin/gem install berkshelf --no-rdoc --no-ri
#/opt/chef/embedded/bin/berks vendor

chef-client -z -c solo.rb -r 'recipe[demoapp]'
