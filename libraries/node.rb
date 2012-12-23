class Chef
  class Node
    def cloud_location(n)
      case n["cloud"]
        when "ec2"  #compare regions
          n["ec2"]["placement_availability_zone"][/([a-z]{2}-[a-z]+-[0-9])[a-z]/,1]
        #when adding new multi-region cloud providers - add cases here
        when nil
          false
        else
          n["cloud"]["provider"] #various single-region providers
      end
    end

    def relative_hostname(other_node=node)
      if not cloud_location(self)
        self["hostname"]
      elsif cloud_location(self) == cloud_location(other_node)
        self["cloud"]["local_hostname"]
      else
        self["cloud"]["public_hostname"]
      end
    end

    def relative_ipv4(other_node=node)
      if not cloud_location(self)
        self["ipaddress"]
      elsif cloud_location(self) == cloud_location(other_node)
        self["cloud"]["local_ipv4"]
      else
        self["cloud"]["public_ipv4"]
      end
    end

    def ip_for_node(other_node)
      ::Fewbytes::Chef::Utils.deprecation_warning("ip_for_node", "relative_ipv4")
      relative_ipv4(other_node)
    end
  end
end


