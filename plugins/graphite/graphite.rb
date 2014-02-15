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

# kludgy reconnect scheme will drop metrics on failure but avoid blocking
writer = ->(){
  tries = 0
  connect = ->() {
    tries += 1
    warn "tries: #{tries}"
    return if tries > 3 and not(tries % 10 == 0)
    warn "reconnect"
    socket = TCPSocket.open(host, port)
    tries = 0
    return socket
  }
  socket = connect[] # connect early -> fail early
  ->(line) {
    begin
      socket ||= connect[] or return
      socket.write(line)
    rescue => err
      warn "graphite error #{err}"
      socket = nil
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
