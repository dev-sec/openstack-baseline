# frozen_string_literal: true

# check-shared-01
describe file('/etc/manila/manila.conf') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'manila' }
end
describe file('/etc/manila/api-paste.ini') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'manila' }
end
describe file('/etc/manila/policy.json') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'manila' }
end
describe file('/etc/manila/rootwrap.conf') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'manila' }
end

# check-shared-02
describe file('/etc/manila/manila.conf') do
  its('mode') { should eq 0o640 }
  it { should exist }
end
describe file('/etc/manila/api-paste.ini') do
  its('mode') { should eq 0o640 }
  it { should exist }
end
describe file('/etc/manila/policy.json') do
  its('mode') { should eq 0o640 }
  it { should exist }
end
describe file('/etc/manila/rootwrap.conf') do
  its('mode') { should eq 0o640 }
  it { should exist }
end

# check-shared-03
describe file('/etc/manila/manila.conf') do
  its('content') { should match 'auth_strategy = keystone' }
end

# check-shared-04
describe file('/etc/manila/manila.conf') do
  its('content') { should match "/\[keystone_authtoken\].*auth_protocol = https/" }
  its('content') { should match "/\[keystone_authtoken\].*identity_uri = https/" }
end

# check-shared-05
describe file('/etc/manila/manila.conf') do
  its('content') { should match "/\[DEFAULT\].*nova_api_insecure = False/" }
end

# check-shared-06
describe file('/etc/manila/manila.conf') do
  its('content') { should match "/\[DEFAULT\].*neutron_api_insecure = False/" }
end

# check-shared-07
describe file('/etc/manila/manila.conf') do
  its('content') { should match "/\[DEFAULT\].*cinder_api_insecure = False/" }
end

# check-shared-08
describe file('/etc/manila/manila.conf') do
  its('content') { should match "/\[DEFAULT\].*osapi_max_request_body_size = 114688/" }
end
