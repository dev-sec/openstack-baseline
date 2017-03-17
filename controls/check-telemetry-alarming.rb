# All checks here are not (yet) in the OpenStack Security Guide
# They are inspired by those at http://docs.openstack.org/security-guide/block-storage/checklist.html

conf_dir = '/etc/aodh'

default_config_files = %w(
  aodh.conf
  api_paste.ini
  policy.json
)

config_files = attribute(
    'aodh_config_files', default: default_config_files,
    description: 'OpenStack AODH configuration files')

aodh_enabled = attribute(
    'aodh_enabled', default: false,
    description: 'OpenStack Inspec checks for AODH should be enabled')

control 'check-telemetry-alarming-01' do

  title 'AODH config files should be owned by root user and aodh group.'
  only_if { aodh_enabled }

  config_files.each do |conf_file|
    describe file("#{conf_dir}/#{conf_file}") do
      it { should be_owned_by 'root' }
      its('group') { should eq 'aodh' }
    end
  end
end

control 'check-telemetry-alarming-02' do

  title 'Strict permissions should be set for all AODH config files.'
  only_if { aodh_enabled}

  config_files.each do |conf_file|
    describe file("#{conf_dir}/#{conf_file}") do
      its('mode') { should cmp '0640' }
    end
  end
end

control 'check-telemetry-alarming-03' do

  title 'AODH should communicate with Keystone using TLS.'
  only_if { aodh_enabled }

  describe ini("#{conf_dir}/aodh.conf") do
    its(['keystone_authtoken','auth_uri']) { should match /^https:/ }

    # nil is acceptable as false is the default value
    its(['keystone_authtoken','insecure']) { should be_nil.or eq "False" }
  end
end
