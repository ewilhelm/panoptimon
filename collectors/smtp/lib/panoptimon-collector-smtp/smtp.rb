module Panoptimon
  module Collector
    class SMTP

      def initialize(options={})
        @options = options
      end

      def options
        @options
      end

      def host
        options['host']
      end

      def port
        options['port']
      end
      
      def connect
        begin
          Timeout::timeout(5) do
            TCPSocket.new(host, port)
          end
        rescue Timeout::Error
          false
        end
      end
      
      def banner
        connect ? {:status => connect.gets.split.first} : nil
      end
    end
  end
end

