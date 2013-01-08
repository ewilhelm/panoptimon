require 'panoptimon/util/string-with-as_number'

class Array; def to_h; Hash[self]; end; end

module Panoptimon
  module Collector
    class HAProxy

      attr_reader :collector, :stats_url

      def initialize(options={})
        url = options[:stats_url] || '/var/run/haproxy.sock'
        @stats_url = url.sub(%r{^socket:/}, '')
        # slash after bare hostname:port
        @stats_url += '/' if @stats_url =~ %r{^https?://[^/]+$}
        @collector = @stats_url !~ %r{^\w+://} \
          ? :stats_from_sock
          : :stats_from_http
      end

      def info
        it = self.class.send(collector, stats_url)
        out = {
          uptime_sec: it[:info][:uptime_sec] ||
            self.class._dhms_as_sec(it[:info][:uptime]),
          status: it[:stats].values.reduce({}) {|c,v|
            v.values.each {|h| s = h[:status].downcase.gsub(/ /, '_')
              c[s] ||= 0; c[s] += 1 }
            c
          },
          _info: {
            status: [:FRONTEND, :BACKEND].map {|s|
                [s, it[:stats][s].map {|n,v|
                  [n, v[:status].downcase]}.to_h]
            }.to_h,
          }.merge([:version].
            map {|k| [k, it[:info][k]]}.to_h),
        }.merge(
          [:process_num, :pid, :nbproc, :run_queue, :tasks].
          map {|k| [k, it[:info][k]]}.to_h)
      end

      def self._dhms_as_sec(dhms)
        f = {'d' => 24*60**2, 'h' => 60**2, 'm' => 60, 's' => 1}
        s = 0;
        dhms.split(/(d|h|m|s) ?/).reverse.each_slice(2) {|p|
          (k, v) = p
          s += v.to_i * f[k]
        }
        return s
      end

      def self.stats_from_sock(path)
        {
          stats: _parse_stats_csv( _sock_get(path, 'show stat') ),
          info:  _parse_show_info( _sock_get(path, 'show info') )
        }
      end

      def self.stats_from_http(uri)
        # NOTE uri is expected to have trailing slash if needed
        {
          stats: _parse_stats_csv(
            _http_get(uri + ';csv').split(/\n/) ),
          info: _parse_html_info( _http_get(uri) )
        }
      end

      def self._parse_html_info(body)
        body =~ %r{General\sprocess\sinformation</[^>]+>
          (.*?Running\stasks:\s\d+/\d+)<}xm or
          raise "body: #{body} does not match expectations"
        p = $1
        info = {}
        # TODO proper dishtml?
        p.gsub!(%r{\s+}, ' ')
        p.gsub!(%r{<br>}, "\n")
        p.gsub!(%r{<[^>]+>}, '')
        p.gsub!(%r{ +}, ' ')
        { # harvest some numbers
          pid:           %r{pid =\s+(\d+)},
          process_num:   %r{process #(\d+)},
          nbproc:        %r{nbproc = (\d+)},
          uptime:        %r{uptime = (\d+d \d+h\d+m\d+s)},
          memmax_mb:     %r{memmax = (unlimited|\d+)},
          :'ulimit-n' => %r{ulimit-n = (\d+)},
          maxsock:       %r{maxsock = (\d+)},
          maxconn:       %r{maxconn = (\d+)},
          maxpipes:      %r{maxpipes = (\d+)},
          currcons:      %r{current conns = (\d+)},
          pipesused:     %r{current pipes = (\d+)/\d+},
          pipesfree:     %r{current pipes = \d+/(\d+)},
          run_queue:     %r{Running tasks: (\d+)/\d+},
          tasks:         %r{Running tasks: \d+/(\d+)},
        }.each {|k,v|
          got = p.match(v) or raise "no match for #{k} (#{v})"
          info[k] = got[1].as_number || got[1]
        }
        info[:memmax_mb] = 0 if info[:memmax_mb] == 'unlimited'

        vi = body.match(%r{<body>.*?>([^<]+)\ version\ (\d+\.\d+\.\d+),
          \ released\ (\d{4}/\d{2}/\d{2})}x) or
          raise "failed to find version info"
        info.merge!( name: vi[1], version: vi[2], release_date: vi[3] )
        return info
      end

      def self._http_get(uri)
        require 'net/http'
        uri = URI(uri)
        res = ::Net::HTTP.start(uri.host, uri.port,
          :use_ssl => uri.scheme == 'https'
        ).request(::Net::HTTP::Get.new(uri.request_uri))
        raise "error: #{res.code} #{res.message}" unless
          res.is_a?(::Net::HTTPSuccess)
        return res.body
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
          h[s.to_sym][n] = Hash[(0..imax).map {|i|
            [hk[i], (f[i].nil? or f[i] == "") ? nil :
              f[i].as_number || f[i]]}]
        }
        return h
      end

      def self._sock_get(path, cmd)
        require "socket"
        stat_socket = UNIXSocket.new(path)
        stat_socket.puts(cmd)
        stat_socket.readlines
      end
    end
  end
end
