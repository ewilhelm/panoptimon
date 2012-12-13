
require 'rusage'

start = then_ = Time.now
rolling = [] # brief history
roll = ->(conf) {
  periods = [60, 15, 5, 1].map {|m| m*60}
  ->(now) {
    horizon = now - periods[0]
    cut_here = -1
    p = 0
    sums = Hash[periods.map {|p| [p, Hash.new(0)]}]
    rolling.each {|x|
    warn "wat #{ x}"
      if p == 0 and x[0] < horizon
        cut_here += 1
        next
      elsif periods[p] and x[0] > now - periods[p]
        p += 1
      end
      periods[p...periods.length].each {|_|
        warn "wat #{_}"
        x[1].each {|k,v| sums[_][k] += v} # min/max/n?
      }
    }
    rolling.slice!(0, cut_here) if cut_here
    return Hash[sums.map {|p,h|
      [p.to_s, Hash[h.map {|k,v| [k, (v.to_f/p).round(4)]}]]
    }]
  }
}[config]

setup = ->() {
EM.add_periodic_timer(config[:interval], ->(){
  now = Time.now
  elapsed = now - then_

  metrics = roll[now].merge({
    'uptime' => (now - start).round(0),
    'rss'    => Process.rusage.maxrss,
  })
  m = Metric.new('daemon_health', metrics)
  warn m
  monitor.bus.notify(m)

  then_ = now
})
}

return ->(metric) {
  return if metric.has_key?('daemon_health|uptime') # skip our own data
  if setup; setup[] ; setup = nil; end
  rolling.push([Time.now, {'metrics' => metric.keys.length}])
}
