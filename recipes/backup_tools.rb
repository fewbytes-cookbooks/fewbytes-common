# install necessary tools for backups
package "s3cmd"

# install s3 copy utility and necessary keys
s3_credentials = node["backups"]["s3_credentials"] or get_credentials("S3", "backup")

template "/root/backup.s3cfg" do
  source "s3cmd.erb"
  mode "0600"
  variables :access_key_id => s3_credentials['aws_access_key_id'],
            :secret_key    => s3_credentials['aws_secret_access_key']
  backup 0
end

directory node["fewbytes"]["tool_dir"] do
    recursive true
end
directory ::File.join(node["fewbytes"]["tool_dir"], "bin")
directory ::File.join(node["fewbytes"]["tool_dir"], "lib")

["backup_file.sh", "backup_mysql.sh", "backup_couchdb.sh"].each do |script|
    cookbook_file ::File.join(node["fewbytes"]["tool_dir"], "bin", script) do
      mode "0755"
    end
end

cookbook_file ::File.join(node["fewbytes"]["tool_dir"], "lib/backup_scripts_lib.sh") do
  mode "0644"
end
