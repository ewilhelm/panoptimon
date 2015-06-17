require 'json'
require 'socket'
require 'openssl'
require 'net/http'

module Panoptimon
  module Collector
    class HTTP
      
      attr_reader :uri, :use_ssl, :timeout, :match, :method
      def initialize(uri, opt = {})
        @uri = URI(uri)
        @use_ssl = @uri.scheme == 'https'
        @timeout = opt[:timeout]
        @match   = opt[:match] ? %r{#{opt[:match]}} : nil
        @method  = opt[:method].downcase.to_sym
        @method = :get if @method == :head and @match
      end

      def connect
        @connect ||= ::Net::HTTP.start(uri.host, uri.port,
          :use_ssl      => use_ssl,
          :open_timeout => timeout,
          )
      end

      def request
        what = {
          head: ::Net::HTTP::Head,
          get:  ::Net::HTTP::Get,
        }[method]
        raise "method #{method} not implemented" unless what
        what.new(uri.request_uri)
      end
      
      def certificate_info (cert, now=Time.now)
        return {
          expires_in: (cert.not_after - now).round(0),
          _info: {
            issuer:  cert.issuer.to_s.match(%r{/O=([^/]+)})[1],
            valid:   cert.not_before.to_s,
            expires: cert.not_after.to_s,
            serial:  sprintf('%032x', cert.serial).to_s.gsub(/(..)(?!$)/, '\1:'),
          }
        }
      end

      def go
        start = Time.now
        response = begin; connect.request(request)
          rescue Timeout::Error; nil ; end

        ans = {
          elapsed: (Time.now - start).round(6),
        }

        return ans.merge({timeout: true}) unless response

        ans.merge!({
          content_length: response.header.content_length,
          code:           response.code,
        })
        ans[:ssl] = certificate_info(connect.peer_cert) if use_ssl

        ans[:ok] = response.body.match(match) ? true : false if match

        (ans[:_info] ||= {})[:redirect] = response.header['Location'] \
          if ans[:code].to_s.match(/^3/)

        return ans
      end      
    end
  end
end
