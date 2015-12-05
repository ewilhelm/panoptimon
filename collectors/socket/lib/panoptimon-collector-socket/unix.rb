module Panoptimon
  module Collector
    class Socket
      class Unix < Panoptimon::Collector::Socket

        def defaults
          super.merge({
            timeout: 5
          })
        end

        def get_banner
          s = UNIXSocket.new(@path)
          s.puts(query) if query
          s.readlines.join('')
        end

      end
    end
  end
end
