define :backup, :bucket => nil, :minute => "0", :hour => "8",
  :command => nil, :nsca_args => "-H %{nsca_host} -P %{nsca_port}" \
do
  backup2s3_path = ::File.join(node["fewbytes"]["tool_dir"], "bin/backup2s3.sh")
  params[:command] = "#{script_path} -j -b #{params[:bucket]} -p #{params[:prefix]}" unless params[:command]
  include_recipe "fewbytes-common::backup_tools"
  nsca_host = provider_for_service("nsca")
  extra_args = ""
  if nsca_host
    extra_args +=
      params[:nsca_args].sub("%{nsca_host}", nsca_host[:ipaddress]).sub("%{nsca_port}", nsca_host[:nagios][:nsca][:port].to_s)
    if node["backups"]["resources"].is_a? Array
      node["backups"]["resources"].push params[:prefix] unless node[:backups].include? params[:prefix]
    else
      node["backups"]["resources"] = [params[:prefix]]
    end
  end
  params[:command] = "#{params[:command]} #{extra_args} #{params[:name]}"
  cron "backup #{params[:name]}" do
    minute params[:minute]
    hour params[:hour]
    command params[:command]
  end
end
