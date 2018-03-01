#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

def service(action)
  case action
  when "build_db"
    cmd_string = "/bin/bash /root/tmp/ogam/scripts/build_db.sh"
  when "build_ogamserver"
    cmd_string = "/bin/bash /root/tmp/ogam/scripts/build_ogamserver.sh"
  when "build_ogamdesktop"
    cmd_string = "/bin/bash /root/tmp/ogam/scripts/build_ogamdesktop.sh"
  when "build_ogamservices"
    cmd_string = "/bin/bash /root/tmp/ogam/scripts/build_ogamservices.sh"
  else
    raise Puppet::Error, "Unknow action: #{action}"
  end
  stdout, stderr, status = Open3.capture3(cmd_string)
  raise Puppet::Error, stderr if status != 0
  { status: "#{action} successful" }
end

params = JSON.parse(STDIN.read)
action = params['action']

begin
  result = service(action)
  puts result.to_json
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message }.to_json)
  exit 1
end
