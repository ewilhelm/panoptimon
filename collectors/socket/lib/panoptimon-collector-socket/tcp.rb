require 'uri'
require 'socket'
require 'timeout'
require 'panoptimon-collector-socket/socket'

module Panoptimon
  module Collector
    class Socket
      class TCP < Panoptimon::Collector::Socket
        attr_accessor :host, :port

        def initialize(options={})
          opt = defaults.merge(options)
          super(opt)
          @port  = opt[:port]
          @host = @path.match('\w+:\/\/') ? URI(@path).host : @path
        end

        def defaults
          super.merge({
             path:    'http://localhost',
             port:    80,
             timeout: 10,
          })
        end

        def get_banner
          TCPSocket.new(host, port).recv(100)
        end

      end
    end
  end
end
