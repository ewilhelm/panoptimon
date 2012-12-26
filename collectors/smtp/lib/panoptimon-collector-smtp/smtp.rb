require "socket"
require "timeout"

module Panoptimon
  module Collector
    class SMTP

      attr_reader :host, :port, :timeout
      def initialize(args={})
        args.each { |k,v| instance_variable_set("@#{k}", v) }
      end

      def collect
        c = begin
          Timeout::timeout(timeout) {
            code = TCPSocket.new(host, port).gets.split.first
            {status: code.to_i}
          }
        rescue Timeout::Error
          {timeout: true}
        rescue
          {error: true, _info: {error: "#{$!.class}: #{$!}"}}
        end

        return c
      end
    end
  end
end

