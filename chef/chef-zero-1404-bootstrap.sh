#!/bin/bash -v

export DEBIAN_FRONTEND=noninteractive
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export HOME=/root
export RUBYOPTS="-E utf-8"
export LANG=C.UTF-8

apt-get -y update
apt-get -y install wget build-essential git
wget --no-verbose --output-document /tmp/chef-omnibus.deb "https://packages.chef.io/stable/ubuntu/10.04/chef_12.9.38-1_amd64.deb"
dpkg --install /tmp/chef-omnibus.deb

mkdir -p /etc/chef
cd /root/
git clone https://github.com/sniperd/sparkle-aws-demo 
cd /root/sparkle-aws-demo
git checkout stelligent

(
cat << 'EOP'
cookbook_path [
"/root/sparkle-aws-demo/chef/cookbooks",
"/root/sparkle-aws-demo/berks-cookbooks"
]
log_level :info
log_location STDOUT
EOP
) > /root/sparkle-aws-demo/zero.rb

/opt/chef/embedded/bin/gem install berkshelf --no-rdoc --no-ri
/opt/chef/embedded/bin/berks vendor

chef-client -z -c zero.rb -r 'recipe[demoapp]'
