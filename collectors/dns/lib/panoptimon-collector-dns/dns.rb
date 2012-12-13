module Panoptimon
  module Collector
    class DNS

      def initialize(options={})
        @options = default.merge!(options)
      end

      def options
        @options
      end

      def default
        {'host' => 'www.google.com', 'type' => 'a'}
      end

      def type
        types[options['type']]
      end      

      def types
        {
          'a'     => Net::DNS::A,
          'mx'    => Net::DNS::MX,
          'ns'    => Net::DNS::NS,
          'ptr'   => Net::DNS::PTR,
          'txt'   => Net::DNS::TXT,
          'cname' => Net::DNS::CNAME
        }
      end

      def host
        options['host']
      end

      def query
        output = []
        response = Resolver(host, type).answer.each(&:value)
        response.each do |record|
          next if (record.nil? || record.value.nil?)
          output << response.first.value.split.last           
        end
        output.empty? ? {:status => 1} : {:status => 0, :response => output}
      end
    end
  end
end


