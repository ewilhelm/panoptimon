# TODO Make the stats string more configurable. Replace "hostname" with an
#      option passed in from upstream somewhere.

require 'rubygems'
require 'socket'

host = config[:host] || 'localhost'
port = config[:port] || '2003'

socket = TCPSocket.open(host, port)

hostname = `hostname -s`.chomp!

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

    stat = "#{hostname}.#{metric} #{metrics[k]} #{t}"
    socket.write("#{stat}\n")
  }
}
