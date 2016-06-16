require 'serverspec'
sleep 60 # sfn-serverspec is in its infancy and does not know how to wait until a server is provisioned.

describe 'My base packages should be installed' do
  describe package('git'), if: os[:family] == 'ubuntu' do
    it { should be_installed }
  end
end
