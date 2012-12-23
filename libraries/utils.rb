module Fewbytes::Chef::Utils
  module_function
  def deprecation_warning(replacement, deprecated=caller[0][/`([^']*)'/, 1])
    ::Chef::Log.warn("#{deprecated} is deprecated, please use #{replacement} instead!")
  end
end
      
