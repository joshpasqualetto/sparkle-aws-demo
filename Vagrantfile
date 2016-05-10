Vagrant.configure("2") do |config|
  config.vm.define "demoapp" do |machine|
    machine.vm.provider "virtualbox" do |vbox|
      vbox.name = "demoapp"
    end
    machine.vm.provision :chef_zero do |chef|
      config.vm.box = 'ubuntu/trusty64'
      chef.log_level = "debug"
      chef.cookbooks_path = "./chef/cookbooks/"
      chef.nodes_path = "./nodes"
      chef.run_list = ['recipe[demoapp]']
    end
  end
end
