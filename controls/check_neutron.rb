# frozen_string_literal: true

# All checks from http://docs.openstack.org/security-guide/networking/checklist.html

neutron_conf_dir = '/etc/neutron'
neutron_conf_file = "#{neutron_conf_dir}/neutron.conf"

control 'check-neutron-01' do
  title 'Neutron config files should be owned by root user and neutron group.'
  ref 'http://docs.openstack.org/security-guide/networking/checklist.html#check-neutron-01-is-user-group-ownership-of-config-files-set-to-root-neutron'

  describe file(neutron_conf_file) do
    it { should be_owned_by 'root' }
    its('group') { should eq 'neutron' }
  end
  describe file("#{neutron_conf_dir}/api-paste.ini") do
    it { should be_owned_by 'root' }
    its('group') { should eq 'neutron' }
  end
  describe file("#{neutron_conf_dir}/policy.json") do
    it { should be_owned_by 'root' }
    its('group') { should eq 'neutron' }
  end
  describe file("#{neutron_conf_dir}/rootwrap.conf") do
    it { should be_owned_by 'root' }
    its('group') { should eq 'neutron' }
  end
end

control 'check-neutron-02' do
  title 'Strict permissions should be set for all Neutron config files.'
  ref 'http://docs.openstack.org/security-guide/networking/checklist.html#check-neutron-02-are-strict-permissions-set-for-configuration-files'

  describe file(neutron_conf_file) do
    its('mode') { should cmp '0640' }
  end
  describe file("#{neutron_conf_dir}/api-paste.ini") do
    its('mode') { should cmp '0640' }
  end
  describe file("#{neutron_conf_dir}/policy.json") do
    its('mode') { should cmp '0640' }
  end
  describe file('/etc/neutron/rootwrap.conf') do
    its('mode') { should cmp '0640' }
  end
end

control 'check-neutron-03' do
  title 'Neutron should use Keystone for authentication.'
  ref 'http://docs.openstack.org/security-guide/networking/checklist.html#check-neutron-03-is-keystone-used-for-authentication'

  describe ini(neutron_conf_file) do
    # nil is acceptable as "keystone" is the default value
    its(%w(DEFAULT auth_strategy)) { should be_nil.or eq 'keystone' }
  end
end

control 'check-neutron-04' do
  title 'Neutron should communicate with Keystone using TLS.'
  ref 'http://docs.openstack.org/security-guide/networking/checklist.html#check-neutron-04-is-secure-protocol-used-for-authentication'

  describe ini(neutron_conf_file) do
    its(%w(keystone_authtoken auth_uri)) { should match(/^https:/) }
    # nil is acceptable as false is the default value
    its(%w(keystone_authtoken insecure)) { should be_nil.or eq 'False' }
  end
end

control 'check-neutron-05' do
  title 'Neutron API server should support TLS.'
  ref 'http://docs.openstack.org/security-guide/networking/checklist.html#check-neutron-05-is-tls-enabled-on-neutron-api-server'

  # TODO: workaround until https://github.com/chef/inspec/issues/1205 is fixed
  unless os.name.nil? # detect mock backend during inspec check
    describe ssl(port: 9696) do
      it { should be_enabled }
    end
  end
end
