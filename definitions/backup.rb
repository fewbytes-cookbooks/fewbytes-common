define :backup, :bucket => nil, :minute => "0", :hour => "8",
  :command => nil, :prefix => "", :nsca_args => "-H %{nsca_host} -P %{nsca_port}" \
do
  include_recipe "fewbytes-common::backup_tools"

  node["backups"]["resources"] |= [params[:prefix]]
  backup2s3_path = ::File.join(node["fewbytes"]["tool_dir"], "bin/backup_file.sh")
  basic_command = params[:command] || "#{backup2s3_path} -j -b #{params[:bucket]} -p #{params[:prefix]}"

  extra_args = Array.new

  nsca_host = provider_for_service("nsca")
  if nsca_host
    extra_args.push params[:nsca_args].sub("%{nsca_host}", nsca_host[:ipaddress]
                                     ).sub("%{nsca_port}", nsca_host[:nagios][:nsca][:port].to_s)
  end

  full_command = "#{basic_command} #{extra_args.join(" ")} #{params[:name]}"
  cron "backup #{params[:name]}" do
    minute params[:minute]
    hour params[:hour]
    command full_command
  end
end
