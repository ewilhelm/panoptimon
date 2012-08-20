#!/usr/bin/ruby

require 'panoptimon'

count = 0
duck = EM.spawn { |metric|
  puts "metric: #{metric.inspect}"
  count += 1
  EM.stop if count >= 5
}

c = Panoptimon::Collector.new(duck,
  'sample_configs/1/collectors/clock/clock',
  {:interval => 0.5})
puts "collector: #{c.inspect}"

EM.run {
  c.run
  EM.add_periodic_timer(0.1) { puts "running: #{c.running?}" }
}
