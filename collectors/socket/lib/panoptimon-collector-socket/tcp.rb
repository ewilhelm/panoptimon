module Panoptimon
  module Collector
    class Socket
      class TCP < Panoptimon::Collector::Socket
		attr_accessor :host, :port

		def initialize(options={})
		  super(options)
		  @port  = options[:port]
		  @match = options[:match]
		end
		
		def defaults
		  { :path       => 'http://www.google.com',
			:port		=> 80,
			:timeout	=> 10,
			:match		=> '.*'
		  }
		end
		
		def host
		  @path.match('\w+:\/\/') ? URI(@path).host : @path
		end
		
		def port
		  @port ||= defaults[:port]
		end
		
		def match 
		  @match ||= defaults[:match]
		end

		def run
		  banner = ''
		  begin
			Timeout::timeout(timeout.to_i) do
			  connection = TCPSocket.new(host, port)
			  banner += connection.recv(100)
			end
		  rescue Timeout::Error
			"Unable to connect to #{host} at #{port}"
		  end
		  {:status => (banner.match(/#{match}/i) ? 0  : 1)}
		end
	  end
	end
  end
end
