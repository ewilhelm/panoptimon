#!/usr/bin/ruby

require 'panoptimon'

m = Panoptimon::Monitor.new

count = 0
bus = EM.spawn { |metric|
  count += 1
  puts "metric: #{metric.inspect} (#{count})"
  m.bus_driver(metric)
  EM.stop if count >= 10
}

m.collectors << Panoptimon::Collector.new(
  bus: bus,
  command: 'sample_configs/1/collectors/clock/clock',
  config: {:interval => 0.5},
)

m.plugins[:hello] = ->(metric){
  puts "#{Time.now} - should do something with #{metric.inspect}"
}

EM.run { m.run }
