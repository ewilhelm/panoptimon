#!/usr/bin/ruby

require 'panoptimon'

count = 0
bus = EM.spawn { |metric|
  count += 1
  puts "metric: #{metric.inspect} (#{count})"
  EM.stop if count >= 2000
}

m = Panoptimon::Monitor.new(
  :collectors => [
    Panoptimon::Collector.new(bus,
      'sample_configs/1/collectors/clock/clock',
      {:interval => 0.5}),
    Panoptimon::Collector.new(bus,
      %q{echo -e '{"everythings_ok" : 1}\n\c' },
      {:interval => 0.03})
  ]
)

EM.run {
  m.run
}
