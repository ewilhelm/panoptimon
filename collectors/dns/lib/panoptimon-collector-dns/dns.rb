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
        Hash[@options[:hosts].map {|name,types|
          # TODO allow aliased name for output?
          # e.g. types.class == Hash ? ...
          [name, Hash[types.map {|t|
            type = t
            records = Resolver(name.to_s,
                Net::DNS.const_get(type.upcase)
              ).answer.map(&:value).
              find_all {|rec| not rec.nil?}.
              map { |rec| rec.split.last }
          [type.downcase, {
            n: records.count,
            _info: {
              records: records
            },
          }]}]]
        }]
      end

    end
  end
end


