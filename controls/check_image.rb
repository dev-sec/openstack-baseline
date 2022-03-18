# frozen_string_literal: true

# All checks here are not (yet) in the OpenStack Security Guide
# They are inspired by those at http://docs.openstack.org/security-guide/block-storage/checklist.html

glance_conf_dir = '/etc/glance'

default_config_files = %w(
  glance-api-paste.ini
  glance-api.conf
  glance-cache.conf
  glance-manage.conf
  glance-registry-paste.ini
  glance-registry.conf
  glance-scrubber.conf
  glance-swift-store.conf
  policy.json
  schema-image.json
  schema.json
)

config_files = input(
  'glance_config_files',
  value: default_config_files,
  description: 'OpenStack Glance configuration files'
)

control 'check-image-01' do
  title 'Glance config files should be owned by root user and glance group.'
  config_files.each do |glance_conf_file|
    describe file("#{glance_conf_dir}/#{glance_conf_file}") do
      it { should be_owned_by 'root' }
      its('group') { should eq 'glance' }
    end
  end
end

control 'check-image-02' do
  title 'Strict permissions should be set for all Glance config files.'
  config_files.each do |glance_conf_file|
    describe file("#{glance_conf_dir}/#{glance_conf_file}") do
      its('mode') { should cmp '0640' }
    end
  end
end

control 'check-image-03' do
  title 'Glance should use Keystone for authentication.'

  # nil is acceptable as keystone is default value
  describe ini("#{glance_conf_dir}/glance-api.conf") do
    its(%w(DEFAULT auth_strategy)) { should be_nil.or eq 'keystone' }
  end
  describe ini("#{glance_conf_dir}/glance-registry.conf") do
    its(%w(DEFAULT auth_strategy)) { should be_nil.or eq 'keystone' }
  end
end

control 'check-image-04' do
  title 'Glance should communicate with Keystone using TLS.'

  describe ini("#{glance_conf_dir}/glance-api.conf") do
    its(%w(keystone_authtoken auth_uri)) { should match(/^https:/) }
    # nil is acceptable as false is the default value
    its(%w(keystone_authtoken insecure)) { should be_nil.or eq 'False' }
  end

  describe ini("#{glance_conf_dir}/glance-registry.conf") do
    its(%w(keystone_authtoken auth_uri)) { should match(/^https:/) }
    # nil is acceptable as false is the default value
    its(%w(keystone_authtoken insecure)) { should be_nil.or eq 'False' }
  end
end
