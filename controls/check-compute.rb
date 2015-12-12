# check-compute-01
describe file('/etc/nova/nova.conf') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'nova' }
end
describe file('/etc/nova/api-paste.ini') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'nova' }
end
describe file('/etc/nova/policy.json') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'nova' }
end
describe file('/etc/nova/rootwrap.conf') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'nova' }
end

# check-compute-02
describe file('/etc/nova/nova.conf') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/nova/api-paste.ini') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/nova/policy.json') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/nova/rootwrap.conf') do
  its('mode') { should eq 0640 }
  it { should exist }
end

# check-compute-03
describe file('/etc/nova/nova.conf') do
    its('content') { should match "auth_strategy = keystone" }
end

# check-compute-04
describe file('/etc/nova/nova.conf') do
  its('content') { should match "/\[keystone_authtoken\].*auth_protocol = https/" }
  its('content') { should match "/\[keystone_authtoken\].*identity_uri = https/" }
end

# check-compute-05
describe file('/etc/nova/nova.conf') do
  its('content') { should match "/\[DEFAULT\].*glance_api_insecure = False/" }
  its('content') { should match "/\[glance\].*api_insecure = False/" }
end
