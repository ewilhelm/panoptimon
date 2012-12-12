require 'json'
require 'socket'
require 'openssl'
require 'net/http'

module Panoptimon
  module Collector
    class HTTP
      
      def initialize(uri)
        @uri = URI(uri)
      end

      private
      
      def uri
        @uri
      end

      def host
        uri.host
      end
      
      def port 
        uri.port
      end
      
      def connect
        @connect ||= ::Net::HTTP.new(uri.host, uri.port)
        @connect.use_ssl = scheme
        @connect
      end
      
      def request
        ::Net::HTTP::Get.new(uri.request_uri)
      end
      
      def response
        connect.request(request)
      end

      def redirect
        connect.is_a?(Net::HTTPRedirection)
      end
      
      def scheme
        uri.scheme == 'https' ?	true : false
      end

      public
      
      def certificate
        @certificate ||= ::Panoptimon::Collector::SSLCertificate.new(uri)
        @certificate.info
      end      

      def status
        scheme ? {:status => response.code}.merge!(certificate) : {:status => response.code}
      end      
    end
  end
end
