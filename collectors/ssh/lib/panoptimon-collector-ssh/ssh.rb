module Panoptimon
  module Collector
    class SSH

      def initialize(options={})
        @options = default_options.merge!(options)
      end
      
      def options
        @options
      end
      
      def default_options
        {:host => 'localhost', :user => 'root', :timeout => 5}
      end
      
      def connect
        @connect ||= ::Net::SSH.start(host, user, :timeout => timeout) rescue 1
      end

      def connected?
        connect.respond_to?('transport') ? (connect.closed? ? false : true) : false
      end

      def version
        @version ||= (connected? ? connect.transport.server_version.version : 1)
      end

      def host
        options['host']
      end
      
      def user
        options['user']
      end

      def timeout 
        options[:timeout]
      end

      def info
        {
          :status  => (connected? ? 0 : 1),
          :version => version
        }
      end
    end
  end
end