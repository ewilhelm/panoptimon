#!/usr/bin/ruby

require 'panoptimon'

count = 0
duck = EM.spawn { |metric|
  count += 1
  puts "metric: #{metric.inspect} (#{count})"
  EM.stop if count >= 500
}

c = Panoptimon::Collector.new(bus: duck,
  command: 'sample_configs/1/collectors/clock/clock',
  # command: %q{echo -e '{"everythings_ok" : 1}\n\c' },
  config: {:interval => 0.5})

puts "collector: #{c.inspect}"
#c.logger.level = ::Logger::DEBUG

EM.run {
  c.run
  EM.add_periodic_timer(1) { puts "running: #{c.running?}" }
}
