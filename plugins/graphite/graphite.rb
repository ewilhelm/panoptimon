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

# attempt to reconnect and resend
# (but avoid over-zealous connect attempts or memory leaks)
# (drops metrics if resend buffer is too large)
writer = ->(){
  buffer = []
  defer = ->(line) {
    buffer.push(line)
    buffer = buffer.drop(50) if buffer.length > 100
  }
  connect = ->() {
    return if buffer.length > 3 and not(buffer.length % 10 == 0)
    socket = TCPSocket.open(host, port)
    socket.write(buffer.slice!(0..buffer.length-1).join('')) \
      if buffer.length > 0
    return socket
  }
  socket = connect[] # connect early -> fail early
  ->(line) {
    begin
      socket ||= connect[] or return nil.tap { defer.call(line) }
      socket.write(line)
    rescue => err
      warn "graphite error: #{err}"
      socket = nil
      defer.call(line)
    end
  }
}[]

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
    writer.call("#{stat}\n")
  }
}
