# check-neutron-01
describe file('/etc/neutron/neutron.conf') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'neutron' }
end
describe file('/etc/neutron/api-paste.ini') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'neutron' }
end
describe file('/etc/neutron/policy.json') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'neutron' }
end
describe file('/etc/neutron/rootwrap.conf') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'neutron' }
end

# check-neutron-02
describe file('/etc/neutron/neutron.conf') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/neutron/api-paste.ini') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/neutron/policy.json') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/neutron/rootwrap.conf') do
  its('mode') { should eq 0640 }
  it { should exist }
end

# check-neutron-03
describe file('/etc/neutron/neutron.conf') do
    its('content') { should match "auth_strategy = keystone" }
end

# check-neutron-04
describe file('/etc/neutron/neutron.conf') do
  its('content') { should match "/\[keystone_authtoken\].*auth_protocol = https/" }
  its('content') { should match "/\[keystone_authtoken\].*identity_uri = https/" }
end

# check-neutron-05
describe file('/etc/neutron/neutron.conf') do
  its('content') { should match "/\[DEFAULT\].*use_ssl = True/" }
end
