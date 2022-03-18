# frozen_string_literal: true

# apache conf checks
# taken from http://docs.openstack.org/security-guide/secure-communication/tls-proxies-and-http-services.html

describe apache_conf do
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
