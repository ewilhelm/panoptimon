require 'socket'

hostname = ->(;h){->(i){
  unless h
    a, b = Socket.gethostname.split(/\./, 2)
    h = {host: a, domain: b}
  end
  h[i.to_sym]
}}[]

host   = config[:host]   || 'localhost'
port   = config[:port]   || '2003'
prefix = config[:prefix] || '<%= host %>'

prefix.gsub!(/<%= *(host|domain) *%>/) { hostname[$1] }

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
