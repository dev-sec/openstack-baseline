# All checks here are not (yet) in the OpenStack Security Guide
# They are inspired by those at http://docs.openstack.org/security-guide/block-storage/checklist.html

conf_dir = '/etc/ceilometer'

default_config_files = %w(
  api_paste.ini
  event_pipeline.yaml
  policy.json
  ceilometer.conf
  event_definitions.yaml
  pipeline.yaml
)

config_files = attribute(
    'ceilometer_config_files', default: default_config_files,
    description: 'OpenStack Ceilometer configuration files')

ceilometer_enabled = attribute(
    'ceilometer_enabled', default: false,
    description: 'OpenStack Inspec checks for Ceilometer should be enabled')

control 'check-telemetry-01' do

  title 'Ceilometer config files should be owned by root user and ceilometer group.'
  only_if { ceilometer_enabled }

  config_files.each do |conf_file|
    describe file("#{conf_dir}/#{conf_file}") do
      it { should be_owned_by 'root' }
      its('group') { should eq 'ceilometer' }
    end
  end
end

control 'check-telemetry-02' do

  title 'Strict permissions should be set for all Ceilometer config files.'
  only_if { ceilometer_enabled }

  config_files.each do |conf_file|
    describe file("#{conf_dir}/#{conf_file}") do
      its('mode') { should cmp '0640' }
    end
  end
end

control 'check-telemetry-03' do

  title 'Ceilometer should use Keystone for authentication.'
  only_if { ceilometer_enabled }

  # nil is acceptable as keystone is default value
  describe ini("#{conf_dir}/ceilometer.conf") do
    its(['DEFAULT','auth_strategy']) { should be_nil.or eq "keystone" }
  end
end

control 'check-telemetry-04' do

  title 'Ceilometer should communicate with Keystone using TLS.'
  only_if { ceilometer_enabled }

  describe ini("#{conf_dir}/ceilometer.conf") do
    its(['keystone_authtoken','auth_uri']) { should match /^https:/ }

    # nil is acceptable as false is the default value
    its(['keystone_authtoken','insecure']) { should be_nil.or eq "False" }
  end
end
