# check-dashboard-01
describe file('/etc/openstack-dashboard/local_settings.py') do
  it { should be_owned_by 'root' }
  its('group') { should eq 'horizon' }
end

# check-dashboard-02
describe file('/etc/openstack-dashboard/local_settings.py') do
  its('mode') { should eq 0640 }
  it { should exist }
end

# check-dashboard-03
describe file('/etc/openstack-dashboard/local_settings.py') do
    its('content') { should match "USE_SSL = True" }
end

# check-dashboard-04
describe file('/etc/openstack-dashboard/local_settings.py') do
    its('content') { should match "CSRF_COOKIE_SECURE = True" }
end

# check-dashboard-05
describe file('/etc/openstack-dashboard/local_settings.py') do
    its('content') { should match "SESSION_COOKIE_SECURE = True" }
end

# check-dashboard-06
describe file('/etc/openstack-dashboard/local_settings.py') do
    its('content') { should match "SESSION_COOKIE_HTTPONLY = True" }
end

# check-dashboard-07
describe file('/etc/openstack-dashboard/local_settings.py') do
    its('content') { should match "password_autocomplete = off" }
end

# check-dashboard-08
describe file('/etc/openstack-dashboard/local_settings.py') do
    its('content') { should match "disable_password_reveal = True" }
end
