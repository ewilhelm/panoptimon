#!/usr/bin/env ruby

require 'rspec'
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'panoptimon-plugin-daemon_health/rollup'

describe('calculate a moving average') {
  it('works') {
    start = Time.now
    roller = Rollup.new(start, {})
    roller.log(x: 60*7)
    out = roller.roll(start+60)
    out['300'][:x][:nps].should == 7
    out['60'][:x][:nps].should == 7
    roller.log(x: 60*7)
    out = roller.roll(start+60*2)
    out['300'][:x][:nps].should == 7
    out['60'][:x][:nps].should == 7
    roller.log(x: 60*1)
    out = roller.roll(start+60*3)
    out['300'][:x][:nps].should == ((60*7+60*7+60).to_f/(60*3)).round(4)
    out['60'][:x][:nps].should == 1
  }
}
