module Panoptimon
  module Collector
    class Socket
      class Unix < Panoptimon::Collector::Socket
		attr_accessor :query

        def initialize(options={})
          super(options)
          @match = options[:match]
        end

      	def defaults
      	  { :path    => '/var/run/haproxy/stats',
            :query   => 'show info',
            :match   => '.*',
            :timeout => 5
          }
      	end

        def socket
		  UNIXSocket.new(@path)
		end

		def write(msg)
		  unix_sock = socket
		  socket.puts(msg)
		  socket
		end
		
        def output
          @output ||= ''
        end
		
      	def run
      	  begin
    	    Timeout::timeout(timeout.to_i) do
			  response = write(query)
			  response.each { |line| output += line.chomp }
			end
      	  rescue Timeout::Error
            "Unable to connect to socket #{path}"
      	  end
          {:status => (output.match(/#{match}/i) ? 0 : 1 )}
        end
      end
    end
  end
end
