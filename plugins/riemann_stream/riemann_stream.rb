require 'rubygems'
require 'riemann/client'

c = Riemann::Client.new(
  host: config[:host] || 'localhost',
  port: config[:port] || 5555,
)

# Try to connect, but no big deal / don't try too hard.
# Riemann is only as reliable as UDP.
5.times do |i|
  sleep(0.25) if i > 0
  begin
    c['false'] # is the fastest query?
    break
  rescue
  end
end and monitor.logger.warn("Cannot connect to riemann #{c.host}:#{c.port}.  Maybe later?")

hostname = config[:hostname] || Socket.gethostname

->(metrics) {

  msg = Riemann::Message.new(:events => metrics.keys.map {|k|
    v = metrics[k]
    v = v.respond_to?(:to_f) ? v.to_f : v ? 1 : 0
    Riemann::Event.new(
      host:    hostname,
      service: k, metric:  v,
      # TODO tags,description,ttl,state configurable?
    )
  })
  begin
    c.send_maybe_recv(msg)
  rescue
    # udp never fails, so treat tcp the same for consistency
    # checking on riemann's health needs to happen elsewhere
  end
}
