swift_config_owner = attribute('swift_config_owner', default: 'root', description: 'OpenStack Swift config file owner')
control 'check-swift-01' do
  describe file('/etc/swift/swift.conf') do
    it { should be_owned_by swift_config_owner }
    its('group') { should eq 'swift' }
    its('mode') { should eq 0640 }
    it { should exist }
  end
end

control 'check-swift-02' do
  describe file('/etc/swift/api-paste.ini') do
    it { should be_owned_by swift_config_owner }
    its('group') { should eq 'swift' }
    its('mode') { should eq 0640 }
    it { should exist }
  end
end

control 'check-swift-03' do
  describe file('/etc/swift/policy.json') do
    it { should be_owned_by swift_config_owner }
    its('group') { should eq 'swift' }
    its('mode') { should eq 0640 }
    it { should exist }
  end
end

control 'check-swift-04' do
  describe file('/etc/swift/rootwrap.conf') do
    it { should be_owned_by swift_config_owner }
    its('group') { should eq 'swift' }
    its('mode') { should eq 0640 }
    it { should exist }
  end
end

control 'check-swift-05' do
  describe port(6002) do
    it { should be_listening }
    its('protocols') {should include 'tcp'}
  end

  describe port(6001) do
    it { should be_listening }
    its('protocols') {should include 'tcp'}
  end

  describe port(6000) do
    it { should be_listening }
    its('protocols') {should include 'tcp'}
  end

  describe port(873) do
    it { should be_listening }
    its('protocols') {should include 'tcp'}
  end
end
