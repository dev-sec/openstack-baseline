# frozen_string_literal: true

# All checks from http://docs.openstack.org/security-guide/identity/checklist.html

keystone_conf_dir = '/etc/keystone'
keystone_conf_file = "#{keystone_conf_dir}/keystone.conf"

control 'check-identity-01' do # rubocop:disable Metrics/BlockLength
  title 'Keystone config files should be owned by keystone user and group.'
  ref 'http://docs.openstack.org/security-guide/identity/checklist.html#check-identity-01-is-user-group-ownership-of-config-files-set-to-keystone'

  describe file(keystone_conf_file) do
    it { should be_owned_by 'keystone' }
    its('group') { should eq 'keystone' }
  end
  describe file("#{keystone_conf_dir}/keystone-paste.ini") do
    it { should be_owned_by 'keystone' }
    its('group') { should eq 'keystone' }
  end
  describe file("#{keystone_conf_dir}/policy.json") do
    it { should be_owned_by 'keystone' }
    its('group') { should eq 'keystone' }
  end

  logging_conf = file("#{keystone_conf_dir}/logging.conf")
  if logging_conf.exist?
    describe logging_conf do
      it { should be_owned_by 'keystone' }
      its('group') { should eq 'keystone' }
    end
  end

  signing_cert = file("#{keystone_conf_dir}/ssl/certs/signing_cert.pem")
  if signing_cert.exist?
    describe signing_cert do
      it { should be_owned_by 'keystone' }
      its('group') { should eq 'keystone' }
    end
  end

  signing_key = file("#{keystone_conf_dir}/ssl/private/signing_key.pem")
  if signing_key.exist?
    describe signing_key do
      it { should be_owned_by 'keystone' }
      its('group') { should eq 'keystone' }
    end
  end

  signing_ca = file("#{keystone_conf_dir}/ssl/certs/ca.pem")
  if signing_ca.exist?
    describe signing_ca do
      it { should be_owned_by 'keystone' }
      its('group') { should eq 'keystone' }
    end
  end
end

control 'check-identity-02' do
  title 'Strict permissions should be set for all Keystone config files.'
  ref 'http://docs.openstack.org/security-guide/identity/checklist.html#check-identity-02-are-strict-permissions-set-for-identity-configuration-files'

  describe file(keystone_conf_file) do
    its('mode') { should cmp '0640' }
  end
  describe file("#{keystone_conf_dir}/keystone-paste.ini") do
    its('mode') { should cmp '0640' }
  end
  describe file("#{keystone_conf_dir}/policy.json") do
    its('mode') { should cmp '0640' }
  end

  logging_conf = file("#{keystone_conf_dir}/logging.conf")
  if logging_conf.exist?
    describe logging_conf do
      its('mode') { should cmp '0640' }
    end
  end

  signing_cert = file("#{keystone_conf_dir}/ssl/certs/signing_cert.pem")
  if signing_cert.exist?
    describe signing_cert do
      its('mode') { should cmp '0640' }
    end
  end

  signing_key = file("#{keystone_conf_dir}/ssl/private/signing_key.pem")
  if signing_key.exist?
    describe signing_key do
      its('mode') { should cmp '0640' }
    end
  end

  signing_ca = file("#{keystone_conf_dir}/ssl/certs/ca.pem")
  if signing_ca.exist?
    describe signing_ca do
      its('mode') { should cmp '0640' }
    end
  end
end

control 'check-identity-03' do
  title 'Keystone API should support TLS.'
  ref 'http://docs.openstack.org/security-guide/identity/checklist.html#check-identity-03-is-tls-enabled-for-identity'
  [5000, 35357].each do |port|
    # TODO: workaround until https://github.com/chef/inspec/issues/1205 is fixed
    next if os.name.nil? # detect mock backend during inspec check

    describe ssl(port: port) do
      it { should be_enabled }
    end
  end
end

control 'check-identity-04' do
  title 'Strong hashing algorithms should be used for PKI tokens'
  ref 'http://docs.openstack.org/security-guide/identity/checklist.html#check-identity-04-does-identity-use-strong-hashing-algorithms-for-pki-tokens'

  keystone_conf = ini(keystone_conf_file)

  only_if do
    keystone_conf.value(%w(token provider)) == 'pki'
  end

  describe ini(keystone_conf_file) do
    its(%w(token hash_algorithm)) { should eq('sha256').or eq('sha384').or eq('sha512') }
  end
end

control 'check-identity-05' do
  title 'Max request body size should be set to avoid denial of service attacks.'
  ref 'http://docs.openstack.org/security-guide/identity/checklist.html#check-identity-05-is-max-request-body-size-set-to-default-114688'

  describe ini(keystone_conf_file) do
    its(%w(oslo_middleware max_request_body_size)) { should be_nil.or be >= 114688 }
  end
end

control 'check-identity-06' do
  title 'Keystone admin token should be disabled.'
  ref 'http://docs.openstack.org/security-guide/identity/checklist.html#check-identity-06-disable-admin-token-in-etc-keystone-keystone-conf'

  describe ini(keystone_conf_file) do
    its(%w(DEFAULT admin_token)) { should be_nil.or eq('None') }
  end
  describe ini("#{keystone_conf_dir}/keystone-paste.ini") do
    its(['pipeline:public_api', 'pipeline']) { should_not include('admin_token_auth') }
    its(['pipeline:admin_api', 'pipeline']) { should_not include('admin_token_auth') }
    its(['pipeline:api_v3', 'pipeline']) { should_not include('admin_token_auth') }
  end
end
