module Panoptimon
  module Collector
    class HAProxy

      attr_reader :options

      def initialize(options={})
        @options = options
        @socket  = options['socket'] ||= '/var/run/haproxy.sock'
      end

      def info
        {
          :status => status,
          :_info  => {
            :backends  => backends,
            :frontends => frontends, 
            :servers   => servers,
            :pid       => pid,
            :version   => version, 
            :uptime    => uptime,
            :processes => processes,
            :nbproc    => nbproc 
          }
        }
      end

      def frontends
        stat('frontend')
      end

      def backends
         stat('backend')
      end

      def servers
        stat('server')
      end

      def pid
        sys('pid')
      end

      def version
        sys('version')
      end

      def uptime
        sys('uptime_sec')       
      end

      def processes
        sys('process_num')
      end

      def nbproc
         sys('nbproc')
      end

      # check if any frontends, backends, or servers are 'DOWN'
      def status
        [ frontends.values,
          backends.values,
          servers.values].include?('DOWN') ? '0' : '1'
      end

      # return information on the haproxy process
      def sys(type)
        output = ''
        write('show info').each do |sys|
          next unless sys.match(/^#{type}/i)
          output += sys.split(':').last.strip
        end
        output
      end

      # return information on frontends, backends, servers, and proxies.
      def stat(type)
        types  = {'frontend' => 1, 'backend' => 2, 'server' => 4}
        output = {}
        write("show stat -1 #{types[type]} -1").each  do |stat|
          next if stat.match('^#')
          stat        = stat.split(',')
          key         = stat.first
          output[key] = stat[17]
        end
        output
      end

      # simple wrapper to communicate with the haproxy stat socket
      def write(cmd)
        stat_socket = UNIXSocket.new(options[:socket])
        stat_socket.puts(cmd)
        stat_socket
      end
    end
  end
end