# Set up Chef handler reporting to graphite
carbon = provider_for_service 'graphite-carbon'
if carbon
  gem_package "chef-handler-graphite" do
      action :nothing
  end.run_action(:install)

  argument_array = [
    :metric_key => "chef.#{node["fewbytes"]["main_role"]}.#{node["fqdn"].sub(".", "-")}",
    :graphite_host => carbon[:ipaddress],
    :graphite_port => carbon["graphite"]["carbon"]["line_receiver_port"]
  ]
  lib_dir = if Gem::Specification.respond_to?(:find_by_name)
    Gem::Specification.find_by_name("chef-handler-graphite").lib_dirs_glob
  else
    Gem::SourceIndex.from_installed_gems.find_name("chef-handler-graphite").last.full_gem_path + "/lib"
  end
  graphite_handler_action = :enable
else
  graphite_handler_action = :disable
end

chef_handler "GraphiteReporting" do
  source "#{lib_dir}/chef-handler-graphite.rb"
  arguments argument_array
  action graphite_handler_action
end

# Set up Chef handler reporting chef run status to nagios via nsca
nsca = provider_for_service "nsca", :fallback_environments => ["_default"]
if nsca
  include_recipe "nagios::nsca-client"

  cookbook_file "/etc/chef/nagios_handler.rb" do
    owner "root"
    mode "644"
  end
  chef_handler "FewBytes::Chef::NagiosHandler" do
    source "/etc/chef/nagios_handler.rb"
    only_if { node.recipe? "nagios::nsca-client" }
    arguments ["chef-client run status", nsca.ip_for_node(node)]
  end
end
