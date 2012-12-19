module Panoptimon
  module Collector
    class DNS

      attr_accessor :options

      def initialize(options={})
        @options = options
      end

      # a:     Net::DNS::A,
      # mx:    Net::DNS::MX,
      # ns:    Net::DNS::NS,
      # ptr:   Net::DNS::PTR,
      # txt:   Net::DNS::TXT,
      # cname: Net::DNS::CNAME

      def query
        Hash[
          @options[:hosts].map {|k,v|
            host = v[0]
            # TODO include record type in output?
            type = Net::DNS.const_get((v[1] || :a).upcase)
            records = Resolver(host, type).answer.map(&:value).
              find_all {|rec| not rec.nil?}.
              map { |rec| rec.split.last }
            [k, {
              n: records.count,
              _info: {
                records: records
              },
            }]
          }]
      end

    end
  end
end


