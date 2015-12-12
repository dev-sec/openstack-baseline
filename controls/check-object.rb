# check-swift-01
describe file('/etc/swift/swift.conf') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'swift' }
end
describe file('/etc/swift/api-paste.ini') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'swift' }
end
describe file('/etc/swift/policy.json') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'swift' }
end
describe file('/etc/swift/rootwrap.conf') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'swift' }
end

# check-swift-02
describe file('/etc/swift/swift.conf') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/swift/api-paste.ini') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/swift/policy.json') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/swift/rootwrap.conf') do
  its('mode') { should eq 0640 }
  it { should exist }
end

# Default listening ports for the various storage services
describe port(6002) do
  it { should be_listening }
  its('protocol') {should eq 'tcp'}
end

describe port(6001) do
  it { should be_listening }
  its('protocol') {should eq 'tcp'}
end

describe port(6000) do
  it { should be_listening }
  its('protocol') {should eq 'tcp'}
end

describe port(873) do
  it { should be_listening }
  its('protocol') {should eq 'tcp'}
end
