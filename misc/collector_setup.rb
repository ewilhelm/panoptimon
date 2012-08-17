#!/usr/bin/ruby

require 'panoptimon'

count = 0
duck = EM.spawn { |metric|
  puts "metric: #{metric.dump}"
  count += 1
  EM.stop if count >= 3
}

c = Panoptimon::Collector.new(duck,
  'sample_configs/1/collectors/clock/clock',
  {:interval => 5})
puts "collector: #{c.inspect}"

EM.run {
  c.run
  EM.add_periodic_timer(1) { puts "running: #{c.is_running?}" }
}
