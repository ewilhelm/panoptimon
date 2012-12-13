module Panoptimon
  module Collector
    class Nginx

      def initialize(options={})
        @options = default_options.merge!(options)
      end

      def options
        @options
      end

      def default_options
        {:url => 'http://localhost/nginx-status'}
      end

      def uri
        @uri ||= URI(options['url'])
      end

      def host
        uri.host
      end

      def port
        uri.port
      end

      def status_uri
        uri.request_uri
      end

      def connect
        @connect ||= Net::HTTP.new(host, port)
      end

      def request
        @request ||= Net::HTTP::Get.new(status_uri)
      end

      def response
        @response ||= connect.request(request)
      end

      def info
        {:total => total, :reading => reading, :writing  => writing, :requests => requests}
      end

      def requests
        response.body.match('\s+(\d+)\s+(\d+)\s+(\d+)')[3]
      end

      def total
        response.body.match('connections:\s(\d+)')[1]
      end

      def reading
        response.body.match('Reading:\s(\d+)')[1]
      end

      def writing
        response.body.match('Writing:\s(\d+)')[1]
      end
    end
  end
end