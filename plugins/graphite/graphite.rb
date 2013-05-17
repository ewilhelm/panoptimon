require 'rubygems'
require 'socket'

hostname = Socket.gethostname.sub(/\..*/, '')

host   = config[:host]   || 'localhost'
port   = config[:port]   || '2003'
prefix = config[:prefix] || hostname

socket = TCPSocket.open(host, port)

->(metrics) {
  t = Time.now.to_i
  metrics.keys.each { |k| 

    metric = k.dup

    # Graphite will use "/" and "." as a delim. Replace with "_".
    # Not great, but... sanitize the output a bit.
    metric.gsub!(/\//, '_')
    metric.gsub!(/\./, '_')

    # Replace pan's default "|" delim with "." so Graphite groups properly.
    metric.gsub!(/\|/, '.')

    stat = "#{prefix}.#{metric} #{metrics[k]} #{t}"
    socket.write("#{stat}\n")
  }
}
