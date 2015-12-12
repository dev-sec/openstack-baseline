# apache conf checks
# taken from http://docs.openstack.org/security-guide/secure-communication/tls-proxies-and-http-services.html

describe apache_conf() do
  its('SSLEngine') { should eq 'On' }
  its('SSLProtocal') { should eq '+TLSv1 +TLSv1.1 +TLSv1.2' }
  its('SSLCipherSuite') { should eq 'HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM' }
  its('SSLSessionTickets') { should eq 'Off' }
end


# disabling self-signed certs for nova
# taken from http://docs.openstack.org/security-guide/identity/authorization.html

describe file('/etc/nova/api.paste.ini') do
    its('content') { should match 'insecure=False' }
end

# API endpoint configuration

# nova configuration
describe file('/etc/nova/nova.conf') do
    its('content') { should match "='https" }
end

# cinder configuration
describe file('/etc/cinder/cinder.conf') do
    its('content') { should match "glance_host ='https" }
end


# Identity settings

# Domains
describe file('/etc/keystone/keystone.conf') do
    its('content') { should match "domain_specific_drivers_enabled = True" }
end

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
  its('mode') { should eq 0644 }
  it { should exist }
end
describe file('/etc/keystone/keystone-paste') do
  its('mode') { should eq 0644 }
  it { should exist }
end
describe file('/etc/keystone/policy.json') do
  its('mode') { should eq 0644 }
  it { should exist }
end
describe file('/etc/keystone/logging.conf') do
  its('mode') { should eq 0644 }
  it { should exist }
end
describe file('/etc/keystone/ssl/certs/siging_cert.pem') do
  its('mode') { should eq 0644 }
  it { should exist }
end
describe file('/etc/keystone/ssl/private/signing_key.pem') do
  its('mode') { should eq 0644 }
  it { should exist }
end
describe file('/etc/keystone/ssl/certs/ca.pem') do
  its('mode') { should eq 0644 }
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
