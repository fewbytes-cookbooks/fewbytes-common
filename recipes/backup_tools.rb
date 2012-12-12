# install necessary tools for backups

include_recipe "fewbytes"
include_recipe "nagios::nsca-client"
package "s3cmd"

# install s3 copy utility and necessary keys
aws_credentials = get_credentials("S3", "backup")

template "/root/backup.s3cfg" do
  source "s3cmd.erb"
  mode "0600"
  variables :access_key_id => aws_credentials['aws_access_key_id'] , :secret_key => aws_credentials['aws_secret_access_key']
  backup 0
end

directory "/opt/fewbytes/bin"
directory "/opt/fewbytes/lib"

cookbook_file "/opt/fewbytes/bin/backup2s3.sh" do
  mode "0755"
end
cookbook_file "/opt/fewbytes/bin/backup_mysql_2_s3.sh" do
  mode "0755"
end
cookbook_file "/opt/fewbytes/lib/backup_scripts_lib.sh" do
  mode "0644"
end