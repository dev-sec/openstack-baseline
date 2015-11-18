# checklist-identity-01
describe file('/etc/keystone/keystone.conf') do
  it { should be_owned_by 'keystone' }
  its('group') { should eq 'keystone' }
end

describe file('/etc/keystone/keystone-paste') do
  it { should be_owned_by 'keystone' }
  its('group') { should eq 'keystone' }
end
describe file('/etc/keystone/policy.json') do
  it { should be_owned_by 'keystone' }
  its('group') { should eq 'keystone' }
end
describe file('/etc/keystone/logging.conf') do
  it { should be_owned_by 'keystone' }
  its('group') { should eq 'keystone' }
end
describe file('/etc/keystone/ssl/certs/siging_cert.pem') do
  it { should be_owned_by 'keystone' }
  its('group') { should eq 'keystone' }
end
describe file('/etc/keystone/ssl/private/signing_key.pem') do
  it { should be_owned_by 'keystone' }
  its('group') { should eq 'keystone' }
end
describe file('/etc/keystone/ssl/certs/ca.pem') do
  it { should be_owned_by 'keystone' }
  its('group') { should eq 'keystone' }
end

# checklist-identity-02
describe file('/etc/keystone/keystone.conf') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/keystone/keystone-paste') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/keystone/policy.json') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/keystone/logging.conf') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/keystone/ssl/certs/siging_cert.pem') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/keystone/ssl/private/signing_key.pem') do
  its('mode') { should eq 0640 }
  it { should exist }
end
describe file('/etc/keystone/ssl/certs/ca.pem') do
  its('mode') { should eq 0640 }
  it { should exist }
end

# checklist-identity-03
describe file('/etc/keystone/keystone.conf') do
    its('content') { should match "/\[ssl\].*enable = True/" }
end

# checklist-identity-04
describe file('/etc/keystone/keystone.conf') do
    its('content') { should match "/\[token\].*hash_algorithm = SHA256/" }
end

# checklist-identity-05
describe file('/etc/keystone/keystone.conf') do
  its('content') { should_not eq "max_request_body_size= " }
  its('content') { should_not eq "max_request_body_size = " }
end

# checklist-identity-06
describe file('/etc/keystone/keystone.conf') do
  its('content') { should eq "admin_token= " }
  its('content') { should eq "admin_token = " }
end

describe file('/etc/keystone/keystone-paste.ini') do
    its('content') { should_not match "AdminTokenAuthMiddleware" }
end
