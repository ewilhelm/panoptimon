require 'panoptimon/util/string-with-as_number'

module Panoptimon
  module Collector
    class HAProxy

      attr_reader :collector, :stats_url

      def initialize(options={})
        url = options[:stats_url] || '/var/run/haproxy.sock'
        @stats_url = url.sub(%r{^socket:/}, '')
        @collector = @stats_url !~ %r{^\w+://} \
          ? :stats_from_sock
          : :stats_from_http
      end

      def info
        # stat: frontend,backend,server
        # sys pid, version, uptime_sec, process_num, nbproc
          # :status => status,
          # :_info  => {
          #   :backends  => backends,
          #   :frontends => frontends, 
          #   :servers   => servers,
          #   :pid       => pid,
          #   :version   => version, 
          #   :uptime    => uptime,
          #   :processes => processes, # process_num ?
          #   :nbproc    => nbproc 
          # }
      end

      # check if any frontends, backends, or servers are 'DOWN'
      def status
        [ frontends.values,
          backends.values,
          servers.values].include?('DOWN') ? '0' : '1'
      end

      def self.stats_from_sock(path)
        {
          stats: _parse_stats_csv(
            sock_command(path, 'show stat').readlines),
          info: _parse_show_info(
            sock_command(path, 'show info').readlines)
        }
      end

      def self.stats_from_http(uri)
      end

      def self._parse_show_info(lines)
        Hash[lines.map {|l|
          (k,v) = * l.chomp.split(/:\s+/, 2);
          k or next
          [k.downcase.to_sym, v.as_number || v]}
        ]
      end

      def self._parse_stats_csv(lines)
        head = lines.shift.chomp.sub(/^# /, '') or raise "no header row?"
        hk = head.split(/,/).map {|k| k.to_sym}; hk.shift(2)
        imax = hk.length - 1
        h = Hash.new {|hash,key| hash[key] = {}}
        lines.each {|l| f = l.chomp.split(/,/)
          (n,s) = f.shift(2)
          h[s][n] = Hash[(0..imax).map {|i|
            [hk[i], (f[i].nil? or f[i] == "") ? nil :
              f[i].as_number || f[i]]}]
        }
        return h
      end

      # simple wrapper to communicate with the haproxy stat socket
      def self.sock_command(path, cmd)
        require "socket"
        stat_socket = UNIXSocket.new(path)
        stat_socket.puts(cmd)
        stat_socket
      end
    end
  end
end
