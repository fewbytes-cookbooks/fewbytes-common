maintainer       "Fewbytes Technologies LTD"
maintainer_email "chef@fewbytes.com"
license          "All rights reserved"
description      "Common libraries"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.2"

recipe "fewbytes-common::admin_workspace", "Prepares an admin workspace with useful tools and rc files"
recipe "fewbytes-common::backup_chef_server", "Backs up the node info from couchDB to S3"
recipe "fewbytes-common::backup_tools", "Configures S3 authentication and backup scripts"
recipe "fewbytes-common::managed-node", "Installs nagios and graphite clients"

depends "chef_handler"
recommends "nagios"
recommends "cluster_service_discovery"
