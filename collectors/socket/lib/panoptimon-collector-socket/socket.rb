module Panoptimon
  module Collector
    class Socket
      attr_accessor :path, :timeout, :match

      def initialize(options={})
      	@path    = options[:path]    || defaults[:path]
        @match   = options[:match]   || defaults[:match]
      	@timeout = options[:timeout] || defaults[:timeout]
      end

      def defaults
      	raise NotImplementedError, "#{self.class} cannot respond to:"
      end
    end
  end
end
