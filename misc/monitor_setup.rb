#!/usr/bin/ruby

require 'panoptimon'

count = 0
bus = EM.spawn { |metric|
  puts "metric: #{metric.inspect}"
  count += 1
  EM.stop if count >= 3
}

m = Panoptimon::Monitor.new(
  :collectors => [
    Panoptimon::Collector.new(bus,
      'sample_configs/1/collectors/clock/clock',
      {:interval => 0.5})
  ]
)

EM.run {
  m.run
}
