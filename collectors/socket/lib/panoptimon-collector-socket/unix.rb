module Panoptimon
  module Collector
    class Socket
      class Unix < Panoptimon::Collector::Socket
        attr_accessor :query

        def initialize(options={})
          opt = super(defaults.merge(options))
          @query = opt[:query]
          opt
        end

        def defaults
          super.merge({
            path:    '/var/run/haproxy/stats',
            query:   'show info',
            timeout: 5
          })
        end

        def get_banner
          UNIXSocket.new(@path).puts(query).readlines.join('')
        end

      end
    end
  end
end
