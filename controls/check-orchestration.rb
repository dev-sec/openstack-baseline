# All checks here are not (yet) in the OpenStack Security Guide
# They are inspired by those at http://docs.openstack.org/security-guide/block-storage/checklist.html

heat_conf_dir = '/etc/heat'

default_config_files = %w(
  api-paste.ini
  heat.conf
  policy.json
  heat_api_audit_map.conf
)

config_files = attribute('heat_config_files', default: default_config_files, description: 'OpenStack Heat configuration files')
heat_enabled = attribute('heat_enabled', default: false, description: 'OpenStack Inspec checks for Heat should be enabled')

control 'check-orchestration-01' do

  title 'Heat config files should be owned by root user and heat group.'
  only_if { heat_enabled }

  config_files.each do |heat_conf_file|
    describe file("#{heat_conf_dir}/#{heat_conf_file}") do
      it { should be_owned_by 'root' }
      its('group') { should eq 'heat' }
    end
  end
end

control 'check-orchestration-02' do

  title 'Strict permissions should be set for all Heat config files.'
  only_if { heat_enabled }

  config_files.each do |heat_conf_file|
    describe file("#{heat_conf_dir}/#{heat_conf_file}") do
      its('mode') { should cmp '0640' }
    end
  end
end

control 'check-orchestration-03' do

  title 'Heat should communicate with Keystone using TLS.'
  only_if { heat_enabled }

  describe ini("#{heat_conf_dir}/heat.conf") do
    its(['keystone_authtoken','auth_uri']) { should match /^https:/ }

    # nil is acceptable as false is the default value
    its(['keystone_authtoken','insecure']) { should be_nil.or eq "False" }
  end
end
