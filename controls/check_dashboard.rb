# frozen_string_literal: true

# All checks from http://docs.openstack.org/security-guide/dashboard/checklist.html

horizon_config_dir = input(
  'horizon_config_dir',
  value: '/etc/openstack-dashboard',
  description: 'OpenStack Dashboard config file path'
)

horizon_config_owner = input(
  'horizon_config_owner',
  value: 'root',
  description: 'OpenStack Dashboard config file owner'
)

horizon_config_group = input(
  'horizon_config_group',
  value: 'horizon',
  description: 'OpenStack Dashboard config file group'
)

control 'check-dashboard-01' do
  title "Horizon config files should be owned by #{horizon_config_owner} user."
  ref 'http://docs.openstack.org/security-guide/dashboard/checklist.html#check-dashboard-01-is-user-group-of-config-files-set-to-root-horizon'

  describe file("#{horizon_config_dir}/local_settings.py") do
    it { should be_owned_by horizon_config_owner }
    its('group') { should eq horizon_config_group }
  end
end

control 'check-dashboard-02' do
  title 'Horizon config files should have strict permissions'
  ref 'http://docs.openstack.org/security-guide/dashboard/checklist.html#check-dashboard-02-are-strict-permissions-set-for-horizon-configuration-files'

  describe file("#{horizon_config_dir}/local_settings.py") do
    its('mode') { should cmp '0640' }
  end
end

control 'check-dashboard-03' do
  title 'Horizon should not allow embedding in iframes.'
  ref 'http://docs.openstack.org/security-guide/dashboard/checklist.html#check-dashboard-03-is-disallow-iframe-embed-parameter-set-to-true'

  describe file("#{horizon_config_dir}/local_settings.py") do
    its('content') { should_not match(/^DISALLOW_IFRAME_EMBED = False$/) }
  end
end

control 'check-dashboard-04' do
  title 'Horizon CSRF cookies should be secure.'
  ref 'http://docs.openstack.org/security-guide/dashboard/checklist.html#check-dashboard-04-is-csrf-cookie-secure-parameter-set-to-true'

  describe file("#{horizon_config_dir}/local_settings.py") do
    its('content') { should match(/^CSRF_COOKIE_SECURE = True$/) }
  end
end

control 'check-dashboard-05' do
  title 'Horizon session cookies should be secure.'
  ref 'http://docs.openstack.org/security-guide/dashboard/checklist.html#check-dashboard-05-is-session-cookie-secure-parameter-set-to-true'
  ref 'https://docs.djangoproject.com/en/1.10/ref/settings/#session-cookie-secure'

  describe file("#{horizon_config_dir}/local_settings.py") do
    its('content') { should match(/^SESSION_COOKIE_SECURE = True$/) }
  end
end

control 'check-dashboard-06' do
  title 'Horizon cookies should not be readable by scripts.'
  ref 'http://docs.openstack.org/security-guide/dashboard/checklist.html#check-dashboard-06-is-session-cookie-httponly-parameter-set-to-true'
  ref 'https://docs.djangoproject.com/en/1.10/ref/settings/#session-cookie-httponly'

  describe.one do
    describe file("#{horizon_config_dir}/local_settings.py") do
      its('content') { should match(/^SESSION_COOKIE_HTTPONLY = True$/) }
    end
    # Default value is true, so no match is fine
    describe file("#{horizon_config_dir}/local_settings.py") do
      its('content') { should_not match(/^SESSION_COOKIE_HTTPONLY =/) }
    end
  end
end

control 'check-dashboard-07' do
  title 'Horizon password autocomplete should be disabled.'
  ref 'http://docs.openstack.org/security-guide/dashboard/checklist.html#check-dashboard-07-is-password-autocomplete-set-to-false'

  describe.one do
    describe file("#{horizon_config_dir}/local_settings.py") do
      its('content') { should match(/^HORIZON_CONFIG\["password_autocomplete"\] = "off"$/) }
    end

    # Default value is off, so no match is fine
    # See http://docs.openstack.org/newton/config-reference/dashboard/config-options.html
    describe file("#{horizon_config_dir}/local_settings.py") do
      its('content') { should_not match(/^HORIZON_CONFIG\["password_autocomplete"\] =/) }
    end
  end
end

control 'check-dashboard-08' do
  title 'Horizon reveal password should be disabled.'
  ref 'http://docs.openstack.org/security-guide/dashboard/checklist.html#check-dashboard-08-is-disable-password-reveal-set-to-true'

  describe file("#{horizon_config_dir}/local_settings.py") do
    its('content') { should match(/^HORIZON_CONFIG\["disable_password_reveal"\] = True$/) }
  end
end

control 'check-dashboard-09' do
  title 'Horizon should require admin password for password changes.'
  ref 'http://docs.openstack.org/security-guide/dashboard/checklist.html#check-dashboard-09-is-enforce-password-check-set-to-true'

  describe file("#{horizon_config_dir}/local_settings.py") do
    its('content') { should match(/^ENFORCE_PASSWORD_CHECK = True$/) }
  end
end

control 'check-dashboard-10' do
  title 'Horizon should be configured with custom password validation regex.'
  ref 'http://docs.openstack.org/security-guide/dashboard/checklist.html#check-dashboard-10-is-password-validator-configured'

  describe file("#{horizon_config_dir}/local_settings.py") do
    its('content') { should_not match(/HORIZON_CONFIG\["password_validator"\] = \{$\s.*"regex": '\.\*',/) }
  end
end

control 'check-dashboard-11' do
  title 'Horizon should be configured with SECURE_SSL_PROXY_HEADER.'
  ref 'http://docs.openstack.org/security-guide/dashboard/checklist.html#check-dashboard-11-is-secure-proxy-ssl-header-configured'

  describe file("#{horizon_config_dir}/local_settings.py") do
    its('content') { should match(/^SECURE_PROXY_SSL_HEADER = \('HTTP_X_FORWARDED_PROTO',\s'https'\)$/) }
  end
end
