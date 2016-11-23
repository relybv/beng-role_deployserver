require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'role_deployserver')
    hosts.each do |host|
      on(host ,'mkdir -p /tmp/modules')
      scp_to host, "#{proj_root}/spec/fixtures/modules", "/tmp", {:ignore => ["role_deployserver"]}
      on(host,'mv /tmp/modules/* /etc/puppet/modules')
    end
  end
end
