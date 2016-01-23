require 'panoptimon-collector-socket/tcp'
require 'panoptimon-collector-socket/unix'

module Panoptimon
  module Collector
    class Socket
      attr_accessor :path, :timeout, :match, :query

      def initialize(options={})
        @path    = options[:path]    || defaults[:path]
        @match   = options[:match]   || defaults[:match]
        @timeout = options[:timeout] || defaults[:timeout]
        @query   = options[:query]   || defaults[:query]
        return options
      end

      # dispatching constructor
      def self.construct(options={})
        (options[:path] =~ %r{^/} ? Unix : TCP).new(options)
      end

      def defaults
        {match:   '.*'}
      end

      def run
        out = begin
          a = Timeout::timeout(timeout.to_i) { get_banner }
          {status: a.match(match) ? true : false}
        rescue Timeout::Error
          {timeout: true}
        end

        out
      end

    end
  end
end
