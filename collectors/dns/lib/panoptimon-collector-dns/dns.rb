class Array; def to_h; Hash[self]; end; end
module Panoptimon
  module Collector
    class DNS

      attr_accessor :options

      def initialize(options={})
        @options = options
      end

      # types: a, mx, ns, ptr, txt, cname, any

      def query
        hosts = @options[:hosts]
        nslist = @options[:nameservers] || [nil]
        nslist.map {|ns|
          dns = ::Net::DNS::Resolver.new(
            ns ? {nameservers: ns} : {})
          [ns || 'default', hosts.map {|name,types|
            # TODO allow aliased name for output?
            # e.g. types.class == Hash ? ...
            # collect results by type regardless of query
            typed = Hash.new { |h,k|
              h[k] = {n: 0, _info: {records: []}} }
            types.each {|t|
              dns.search(name.to_s, Net::DNS.const_get(t.upcase)).
              answer.each { |rec|
                stash = typed[rec.type.downcase]
                stash[:n] += 1
                stash[:_info][:records].push(rec.value)
              }
            }
            [name, typed]
          }.to_h]
        }.to_h
      end

    end
  end
end


