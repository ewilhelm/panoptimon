module Panoptimon
  module Collector
    class Ping
      def initialize(options={})
	@options = options
      end

      def options
	@options
      end

      def host
	options['host']
      end

      def timeout
	options['timeout']
      end

      def ping
	@ping ||= ::Net::Ping::ICMP.new
	@ping.host    = host
	@ping.timeout = timeout
	{:status => (@ping.ping? ? '0' : '1')}
      end
    end
  end
end
