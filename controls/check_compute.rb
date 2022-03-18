# frozen_string_literal: true

# All checks from http://docs.openstack.org/security-guide/compute/checklist.html

nova_conf_dir = '/etc/nova'
nova_conf_file = "#{nova_conf_dir}/nova.conf"

control 'check-compute-01' do
  title 'Nova config files should be owned by root user and nova group.'
  ref 'http://docs.openstack.org/security-guide/compute/checklist.html#check-compute-01-is-user-group-ownership-of-config-files-set-to-root-nova'

  describe file(nova_conf_file) do
    it { should be_owned_by 'root' }
    its('group') { should eq 'nova' }
  end
  describe file("#{nova_conf_dir}/api-paste.ini") do
    it { should be_owned_by 'root' }
    its('group') { should eq 'nova' }
  end
  describe file("#{nova_conf_dir}/policy.json") do
    it { should be_owned_by 'root' }
    its('group') { should eq 'nova' }
  end
  describe file("#{nova_conf_dir}/rootwrap.conf") do
    it { should be_owned_by 'root' }
    its('group') { should eq 'nova' }
  end
end

control 'check-compute-02' do
  title 'Strict permissions should be set for all Nova config files.'
  ref 'http://docs.openstack.org/security-guide/compute/checklist.html#check-compute-02-are-strict-permissions-set-for-configuration-files'

  describe file(nova_conf_file) do
    its('mode') { should cmp '0640' }
  end
  describe file("#{nova_conf_dir}/api-paste.ini") do
    its('mode') { should cmp '0640' }
  end
  describe file("#{nova_conf_dir}/policy.json") do
    its('mode') { should cmp '0640' }
  end
  describe file("#{nova_conf_dir}/rootwrap.conf") do
    its('mode') { should cmp '0640' }
  end
end

control 'check-compute-03' do
  title 'Nova should use Keystone for authentication.'
  ref 'http://docs.openstack.org/security-guide/compute/checklist.html#check-compute-03-is-keystone-used-for-authentication'

  describe ini(nova_conf_file) do
    # nil is acceptable as "keystone" is the default value
    its(%w(DEFAULT auth_strategy)) { should be_nil.or eq 'keystone' }
  end
end

control 'check-compute-04' do
  title 'Nova should communicate with Keystone using TLS.'
  ref 'http://docs.openstack.org/security-guide/compute/checklist.html#check-compute-04-is-secure-protocol-used-for-authentication'

  describe ini(nova_conf_file) do
    its(%w(keystone_authtoken auth_uri)) { should match(/^https:/) }
    # nil is acceptable as false is the default value
    its(%w(keystone_authtoken insecure)) { should be_nil.or eq 'False' }
  end
end

control 'check-compute-05' do
  title 'Nova should communicate with Glance using TLS.'
  ref 'http://docs.openstack.org/security-guide/compute/checklist.html#check-compute-05-does-nova-communicate-with-glance-securely'

  describe ini(nova_conf_file) do
    its(%w(glance api_servers)) { should match(/^https:/) }
    # nil is acceptable as false is the default value
    its(%w(glance api_insecure)) { should be_nil.or eq 'False' }
  end
end
