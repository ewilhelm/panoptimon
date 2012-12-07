require 'socket'
require 'openssl'

module Panoptimon
  module Collector
    class SSLCertificate
      
      def initialize(uri)
        @uri = uri
      end

      private

      def uri
        @uri
      end

      def cert
        connect.peer_cert_chain.first
      end      
      
      def context
        ::OpenSSL::SSL::SSLContext.new
      end

      def connect
        @connect ||=
        ::OpenSSL::SSL::SSLSocket.new(tcp_connect, context).connect
      end

      def tcp_connect
        ::TCPSocket.new(host, port)
      end

      public

      def host
        uri.host
      end

      def port
        uri.port
      end
      
      def expiry
        cert.not_after
      end
      
      def epoch
        cert.not_before
      end
      
      def issuer
        cert.issuer.to_s.match(/O=(\w+)/)[1]
      end

      def info
        {:epoch => epoch, :expires => expiry, :issuer  => issuer}
      end
    end
  end
end
