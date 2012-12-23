# Copyright: Fewbytes Technologies LTD. 2011, 2012
# License: Apache2

module Fewbytes; end #create if missing
module Fewbytes::Chef; end #create if missing

module Fewbytes::Chef::Utils
  module_function
  def deprecation_warning(replacement, deprecated=caller[0][/`([^']*)'/, 1])
    ::Chef::Log.warn("#{deprecated} is deprecated, please use #{replacement} instead!")
  end
end
      
