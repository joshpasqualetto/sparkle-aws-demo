require 'serverspec'
describe 'My demoapp should be running' do
  describe port(80) do
    it { should be_listening }
  end

  describe command('curl http://localhost/') do
    its(:stdout) { should contain('Automation for the People') }
  end
end
