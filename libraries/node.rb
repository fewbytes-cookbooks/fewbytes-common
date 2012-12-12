class Chef
  class Node
    def ip_for_node(other_node)
      # for EC2, check if nodes are on the same region
      if self["cloud"]["provider"] == "ec2"
        if self["ec2"]["placement_availability_zone"][/([a-z]{2}-[a-z]+-[0-9])[a-z]/,1] == \
            node["ec2"]["placement_availability_zone"][/([a-z]{2}-[a-z]+-[0-9])[a-z]/,1]
          self["cloud"]["local_ipv4"] 
        else
          self["cloud"]["public_ipv4"]
        end
      else
        if self["cloud"]["provider"] == other_node["cloud"]["provider"]
          self["cloud"]["local_ipv4"]
        else
          self["cloud"]["public_ipv4"]
        end
      end
    end
  end
end


