# encoding: utf-8
# check-messaging
# http://docs.openstack.org/security-guide/messaging.html

RABBITMQ_CONF_DIR = attribute(
  'rabbitmq_conf_dir',
  description: 'Path to rabbitmq configuration folder',
  default: '/etc/rabbitmq'
)

RABBITMQ_CONF_FILE = attribute(
  'rabbitmq_conf_file',
  description: 'Path to rabbitmq configuration file',
  default: '/etc/rabbitmq/rabbitmq.config'
)

TLSCACERT = attribute(
  'tlscacert',
  description: 'Trust certificates which is signed only by this CA',
  default: '/etc/ssl/testca/cacert.pem'
)

TLSCERT = attribute(
  'tlscert',
  description: 'Rabbitmq server certificate',
  default: '/etc/ssl/server/cert.pem'
)

TLSKEY = attribute(
  'tlskey',
  description: 'Rabbitmq server key',
  default: '/etc/ssl/server/key.pem'
)

TLSPORT = attribute(
  'tlsport',
  description: 'Specify rabbitmq tls server port',
  default: '5671'
)

control 'check-messaging-01' do
  title 'Check Rabbitmq config folder and file owner, group and permissions.'
  desc 'Rabbitmq config files should be owned by root user and root group'
  ref 'Rabbitmq Security', url: 'https://docs.openstack.org/security-guide/messaging/security.html'

  describe file(RABBITMQ_CONF_DIR) do
    it { should exist }
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_readable.by('owner') }
    it { should be_readable.by('group') }
    it { should be_readable.by('other') }
    it { should be_executable.by('owner') }
    it { should be_executable.by('group') }
    it { should be_executable.by('other') }
    it { should be_writable.by('owner') }
    it { should_not be_writable.by('group') }
    it { should_not be_writable.by('other') }
  end

  describe file(RABBITMQ_CONF_FILE) do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should_not be_executable }
    it { should be_readable.by('owner') }
    it { should be_readable.by('group') }
    it { should be_readable.by('other') }
    it { should be_writable.by('owner') }
    it { should_not be_writable.by('group') }
    it { should_not be_writable.by('other') }
  end
end

control 'check-messaging-02' do
  title 'Rabbitmq should listen only on ssl port'
  desc 'The tcp_listeners option is set to [] to prevent it from listening on a non-SSL port.'
  ref 'Rabbitmq Security', url: 'https://docs.openstack.org/security-guide/messaging/security.html'

  describe rabbitmq_config.params('rabbit', 'tcp_listeners') do
    it { should be_empty }
  end
  describe rabbitmq_config.params('rabbit', 'ssl_listeners') do
    it { should cmp TLSPORT }
  end
end

control 'check-messaging-03' do
  title 'Check rabbitmq SSL certificate configuration'
  desc 'Check if the correct ca and server certificate implemented and server key. The rabbitmq server should also check the client certificates.'
  ref 'Rabbitmq Security', url: 'https://docs.openstack.org/security-guide/messaging/security.html'

  describe rabbitmq_config.params('rabbit', 'ssl_options', 'cacertfile') do
    it { should cmp TLSCACERT }
  end
  describe rabbitmq_config.params('rabbit', 'ssl_options', 'certfile') do
    it { should cmp TLSCERT }
  end
  describe rabbitmq_config.params('rabbit', 'ssl_options', 'keyfile') do
    it { should cmp TLSKEY }
  end
end

control 'check-messaging-04' do
  title 'Check rabbitmq check peer certificates'
  desc 'Rabbitmq should verify the certificates from the clients and if the server does not receive a valid certificate it should not allow the connection from the client.'
  ref 'Rabbitmq Security', url: 'https://docs.openstack.org/security-guide/messaging/security.html'

  describe rabbitmq_config.params('rabbit', 'ssl_options', 'verify') do
    it { should cmp 'verify_peer' }
  end
  describe rabbitmq_config.params('rabbit', 'ssl_options', 'fail_if_no_peer_cert') do
    it { should cmp 'true' }
  end
end

control 'check-messaging-05' do
  title 'Check rabbitmq use only TLSv1.2'
  desc 'Rabbitmq should only use TLSv1.2.'
  ref 'Rabbitmq Security', url: 'https://docs.openstack.org/security-guide/messaging/security.html'

  describe rabbitmq_config.params('ssl', 'versions') do
    it { should cmp 'tlsv1.2' }
  end
  describe rabbitmq_config.params('rabbit', 'ssl_options', 'versions') do
    it { should cmp 'tlsv1.2' }
  end
end

control 'check-messaging-06' do
  title 'Check for strong ciphers'
  desc 'Use only strong ciphers for the rabbitmq TLSv1.2 connection.'
  ref 'BSI recommendation', url: 'https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Publikationen/TechnischeRichtlinien/TR02102/BSI-TR-02102-2.pdf;jsessionid=30F658ACD2A772B0A2430C4DEC4AF7D1.1_cid341?__blob=publicationFile&v=4'
  ref 'Mozilla recommendation', url: 'https://wiki.mozilla.org/Security/Server_Side_TLS#Modern_compatibility'

  describe rabbitmq_config.params('rabbit', 'ssl_options', 'ciphers') do
    it { should eq [['ecdhe_ecdsa', 'aes_256_gcm', 'null', 'sha384'], ['ecdhe_rsa', 'aes_256_gcm', 'null', 'sha384'], ['ecdhe_ecdsa', 'aes_128_gcm', 'null', 'sha256'], ['ecdhe_rsa', 'aes_128_gcm', 'null', 'sha256']] }
  end
end

control 'check-messaging-07' do
  title 'Check for tls cipher honor order'
  desc 'The rabbitmq server should force the tls cipher order'
  ref 'Strong Ciphers for Apache, nginx and Lighttpd', url: 'https://cipherli.st/'

  describe rabbitmq_config.params('rabbit', 'ssl_options', 'honor_cipher_order') do
    it { should eq true }
  end
end
