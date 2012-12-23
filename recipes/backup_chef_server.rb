include_recipe "fewbytes-common::backup_tools"
package "python-couchdb"

backup "/etc/chef" do
  bucket node["backups"]["s3_bucket"]
  prefix "chef-etc"
end

backup "couchdb" do
  command "backup_couchdb.sh -b #{node["backups"]["s3_bucket"]} -n #{node.name} -s \"backup couchdb-chef\" chef"
  prefix "couchdb-chef"
end
