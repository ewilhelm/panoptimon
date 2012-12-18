
require 'rusage'
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'panoptimon-plugin-daemon_health/rollup'

config[:interval] ||= 60

start = then_ = Time.now
rolling = Rollup.new(start, config) # brief history

setup = ->() {
EM.add_periodic_timer(config[:interval], ->(){
  now = Time.now
  elapsed = now - then_

  metrics = rolling.roll(now).merge({
    'uptime' => (now - start).round(0),
    'rss'    => Process.rusage.maxrss,
    collectors:     monitor.collectors.length,
    active_plugins: monitor.plugins.keys.length,
    loaded_plugins: monitor.loaded_plugins.keys.length,
  })
  m = Metric.new('daemon_health', metrics)
  monitor.bus.notify(m)

  then_ = now
})
}

return ->(metric) {
  return if metric.has_key?('daemon_health|uptime') # skip our own data
  if setup; setup[] ; setup = nil; end
  rolling.log(metrics: metric.keys.length)
}
