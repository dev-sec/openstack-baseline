# check-block-01
describe file('/etc/cinder/cinder.conf') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'cinder' }
end
describe file('/etc/cinder/api-paste.ini') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'cinder' }
end
describe file('/etc/cinder/policy.json') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'cinder' }
end
describe file('/etc/cinder/rootwrap.conf') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'cinder' }
end

# check-block-02
describe file('/etc/cinder/cinder.conf') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/cinder/api-paste.ini') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/cinder/policy.json') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/cinder/rootwrap.conf') do
  its('mode') { should eq 0640 }
  it { should exist }
end

# check-block-03
describe file('/etc/cinder/cinder.conf') do
    its('content') { should match "auth_strategy = keystone" }
end

# check-block-04
describe file('/etc/cinder/cinder.conf') do
  its('content') { should match "/\[keystone_authtoken\].*auth_protocol = https/" }
  its('content') { should match "/\[keystone_authtoken\].*identity_uri = https/" }
end

# check-block-05
describe file('/etc/cinder/cinder.conf') do
  its('content') { should match "/\[DEFAULT\].*nova_api_insecure = False/" }
end

# check-block-06
describe file('/etc/cinder/cinder.conf') do
  its('content') { should match "/\[DEFAULT\].*glance_api_insecure = False/" }
end

# check-block-07
describe file('/etc/cinder/cinder.conf') do
  its('content') { should match "/\[DEFAULT\].*nas_secure_file_permissions = auto/" }
end

# check-block-08
describe file('/etc/cinder/cinder.conf') do
  its('content') { should match "/\[DEFAULT\].*osapi_max_request_body_size = 114688/" }
end
