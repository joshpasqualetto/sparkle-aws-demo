require 'serverspec'

describe 'My base packages should be installed' do
  describe package('git'), if: os[:family] == 'ubuntu' do
    it { should be_installed }
  end
end
