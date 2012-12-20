module Panoptimon
  module Collector
    class Nginx

      attr_reader :uri
      def initialize(options={})
        options = default_options.merge!(options)
        @uri = URI(options[:url])
      end

      def default_options
        {url: 'http://localhost/nginx-status'}
      end

      def connect
        @connect ||= Net::HTTP.new(uri.host, uri.port)
      end

      def request
        @request ||= Net::HTTP::Get.new(uri.request_uri)
      end

      def response
        @response ||= connect.request(request)
      end

      def info(body=nil)
        body ||= response.body
        raise "not a status report page" if body.match('<') and
          not body.match(/^Active/)
        begin
          {
            requests: body.match('\s+(\d+)\s+(\d+)\s+(\d+)')[3].to_i,
            total:    body.match('connections:\s(\d+)')[1].to_i,
            reading:  body.match('Reading:\s(\d+)')[1].to_i,
            writing:  body.match('Writing:\s(\d+)')[1].to_i
          }
        rescue NoMethodError
          raise "probably not status page"
        end
      end

    end
  end
end
