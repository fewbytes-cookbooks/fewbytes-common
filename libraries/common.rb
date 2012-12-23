# Copyright: Fewbytes Technologies LTD. 2011, 2012
# License: Apache2
#
module Fewbytes
  module Chef
    module Common

      def search_within_environment(index_name, query)
        ::Chef::Log.debug("[Fewbytes::Common::search_within_environment] (#{index_name}, #{query})")
        q = query + " AND environment:#{node.chef_environment}"
        ::Chef::Log.debug("[Fewbytes::Common::search_within_environment] real query: #{q}")
        ret = search(index_name, q)
        ::Chef::Log.debug("[Fewbytes::Common::search_within_environment] results count: #{ret.count}")
        ret
      end

      def get_credentials(*hints)
        raise ::Chef::Exceptions::InvalidDataBagItemID, "Can't find credentials without hints!" if hints.count == 0
        ret = search_within_environment(:credentials, hints.map{|h| "usage:#{h}"}.join(" AND "))
        raise ::Chef::Exceptions::InvalidDataBagItemID, "Can't find credentials for usage: #{hints} (environment #{node.chef_environment})" if ret.count == 0
        ret.first
      end

      def get_endpoint(hints = {})
        ::Fewbytes::Chef::Utils.deprecation_warning "service_discovery cookbook"
        raise ::Chef::Exceptions::InvalidDataBagItemID, "Can't find endpoint without hints!" if hints.count == 0
        query = hints.map do |k,v|
          if v.is_a? Array
            v.map{|value| "#{k}:#{val}" }
          else
            "#{k}:#{v}"
          end
        end.flatten.join(" AND ")
        search_within_environment(:endpoints, query).first
      end

      def get_app_config(app)
        config_bag = data_bag_item("app_config", app)
        if config_bag.nil?
          raise ::Chef::Exceptions::InvalidDataBagItemID, "Missing application config data bag item for %s" % app
        end
        if config_bag.has_key? node.chef_environment
          return config_bag.fetch("default", Hash.new).merge(config_bag[node.chef_environment])
        else
          return config_bag["default"]
        end
      end
    end
  end
end

class ::Chef::Recipe              ; include Fewbytes::Chef::Common ; end
class ::Chef::Resource::Directory ; include Fewbytes::Chef::Common ; end
class ::Chef::Resource            ; include Fewbytes::Chef::Common ; end
class ::Chef::Provider            ; include Fewbytes::Chef::Common ; end
