# frozen_string_literal: true

# All checks from http://docs.openstack.org/security-guide/block-storage/checklist.html

cinder_conf_dir = '/etc/cinder'
cinder_conf_file = "#{cinder_conf_dir}/cinder.conf"

control 'check-block-01' do
  title 'Cinder config files should be owned by root user and cinder group.'
  ref 'http://docs.openstack.org/security-guide/block-storage/checklist.html#check-block-01-is-user-group-ownership-of-config-files-set-to-root-cinder'

  describe file(cinder_conf_file) do
    it { should be_owned_by 'root' }
    its('group') { should eq 'cinder' }
  end
  describe file("#{cinder_conf_dir}/api-paste.ini") do
    it { should be_owned_by 'root' }
    its('group') { should eq 'cinder' }
  end
  describe file("#{cinder_conf_dir}/policy.json") do
    it { should be_owned_by 'root' }
    its('group') { should eq 'cinder' }
  end
  describe file("#{cinder_conf_dir}/rootwrap.conf") do
    it { should be_owned_by 'root' }
    its('group') { should eq 'cinder' }
  end
end

control 'check-block-02' do
  title 'Strict permissions should be set for all Cinder config files.'
  ref 'http://docs.openstack.org/security-guide/block-storage/checklist.html#check-block-02-are-strict-permissions-set-for-configuration-files'

  describe file(cinder_conf_file) do
    its('mode') { should cmp '0640' }
  end
  describe file("#{cinder_conf_dir}/api-paste.ini") do
    its('mode') { should cmp '0640' }
  end
  describe file("#{cinder_conf_dir}/policy.json") do
    its('mode') { should cmp '0640' }
  end
  describe file("#{cinder_conf_dir}/rootwrap.conf") do
    its('mode') { should cmp '0640' }
  end
end

control 'check-block-03' do
  title 'Cinder should use Keystone for authentication.'
  ref 'http://docs.openstack.org/security-guide/block-storage/checklist.html#check-block-03-is-keystone-used-for-authentication'

  # nil is acceptable as keystone is default value
  describe ini(cinder_conf_file) do
    its(%w(DEFAULT auth_strategy)) { should be_nil.or eq 'keystone' }
  end
end

control 'check-block-04' do
  title 'Cinder should communicate with Keystone using TLS.'
  ref 'http://docs.openstack.org/security-guide/block-storage/checklist.html#check-block-04-is-tls-enabled-for-authentication'

  describe ini(cinder_conf_file) do
    its(%w(keystone_authtoken auth_uri)) { should match(/^https:/) }
    # nil is acceptable as false is the default value
    its(%w(keystone_authtoken insecure)) { should be_nil.or eq 'False' }
  end
end

control 'check-block-05' do
  title 'Cinder should communicate with Nova using TLS.'
  ref 'http://docs.openstack.org/security-guide/block-storage/checklist.html#check-block-05-does-cinder-communicate-with-nova-over-tls'

  # nil is acceptable as false is the default value
  describe ini(cinder_conf_file) do
    its(%w(DEFAULT nova_api_insecure)) { should be_nil.or eq 'False' }
  end
end

control 'check-block-06' do
  title 'Cinder should communicate with Glance using TLS.'
  ref 'http://docs.openstack.org/security-guide/block-storage/checklist.html#check-block-06-does-cinder-communicate-with-glance-over-tls'

  describe ini(cinder_conf_file) do
    # nil is acceptable as the glance endpoint may be sourced from Keystone based on the value of glance_catalog_info
    its(%w(DEFAULT glance_api_servers)) { should be_nil.or match(/^https:/) }
    # nil is acceptable as false is the default value
    its(%w(DEFAULT glance_api_insecure)) { should be_nil.or eq 'False' }
  end
end

control 'check-block-07' do
  title 'Cinder should use secure NAS permissions.'
  ref 'http://docs.openstack.org/security-guide/block-storage/checklist.html#check-block-07-is-nas-operating-in-a-secure-environment'

  cinder_conf = ini(cinder_conf_file)

  only_if do
    cinder_conf.value(%w(DEFAULT nas_host)).nil?
  end

  describe ini(cinder_conf_file) do
    # nil is acceptable as auto is the default value
    its(%w(DEFAULT nas_secure_file_permissions)) { should be_nil.or eq('True').or eq('auto') }
    # nil is acceptable as auto is the default value
    its(%w(DEFAULT nas_secure_file_operations)) { should be_nil.or eq('True').or eq('auto') }
  end
end

control 'check-block-08' do
  title 'Max request body size should be set to avoid denial of service attacks.'

  ref 'http://docs.openstack.org/security-guide/block-storage/checklist.html#check-block-08-is-max-size-for-the-body-of-a-request-set-to-default-114688'

  describe ini(cinder_conf_file) do
    # nil is acceptable as 114688 is the default value
    its(%w(DEFAULT osapi_max_request_body_size)) { should be_nil.or be >= 114688 }
  end
end
