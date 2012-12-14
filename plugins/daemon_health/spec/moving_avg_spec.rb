#!/usr/bin/env ruby

require 'rspec'
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'panoptimon-plugin-daemon_health/rollup'

describe('calculate a moving average') {
  it('works') {
    start = Time.now
    roller = Rollup.new(start, {})
    roller.log(start, {x: 7})
    out = roller.roll(start+1)
    p out
    out[:x]['per_second'].should == 7
  }
}
