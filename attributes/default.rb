default["fewbytes"]["main_role"] = "generic"
default["fewbytes"]["tool_dir"] = "/opt/fewbytes"

default["backups"]["resources"] = []
default["backups"]["s3_bucket"] = "" #this must be filled to allow backups

#fill these for use in vhef-solo, but leave empty if using server so they'll be fetched from search
default["backups"]["s3_credentials"] = nil #{'aws_access_key_id' => "key", 'aws_secret_access_key' => "secret"}