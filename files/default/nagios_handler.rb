module FewBytes
  module Chef
    class NagiosHandler < ::Chef::Handler
      include ::Chef::Mixin::Command
      include ::Chef::Mixin::Language
      attr_reader :service_name, :default_monitor_port, :default_monitor_address
      def initialize(svc_name, monitor_host=nil, monitor_port=5667)
        @service_name = svc_name
        @monitor_address = monitor_host
        @monitor_port = monitor_port
      end
      def report
        ::Chef::Log.info "Running NSCA hook"
        if @monitor_address.nil?
          ::Chef::Log.info "NSCA Hook: Could not find monitor and no default monitor was defined, skipping"
          return false 
        end
        node_name = node['nagios']['host_name'] || node[:hostname] || node[:fqdn] || node.name
        if run_status.success?
          status = "OK|run_duration:#{elapsed_time}"
          status_code = 0
        else
          status = run_status.formatted_exception
          status_code = 1
        end
        check_result = [node_name, service_name, status_code, status].join("/")
        return_code = run_command(
          :command => %Q(echo "#{check_result.gsub(/(["`])/, '\\\1')}" | send_nsca -H #{@monitor_address} -p #{@monitor_port} -d '/'), 
          :timeout => 30, :environment => {"PATH" => "/sbin:/usr/sbin:/bin:/usr/bin"})
        ::Chef::Log.info "send_nsca returned #{return_code}"
      end
    end
  end
end
