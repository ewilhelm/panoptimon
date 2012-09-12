require 'rubygems'
require 'riemann/client'

c = Riemann::Client.new(
  host: config[:host] || 'localhost',
  port: config[:port] || 5555,
)

hostname = config[:hostname] || Socket.gethostname

->(metrics) {
  c.send_maybe_recv(Riemann::Message.new(:events =>
    metrics.keys.map {|k|
      v = metrics[k]
      v = v.respond_to?(:to_f) ? v : v ? 1 : 0
      Riemann::Event.new(
        host:    hostname,
        service: k, metric:  v,
        # TODO tags,description,ttl,state configurable?
      )
    }
  ))
}
