#!/usr/bin/env ruby

require 'panoptimon'

describe('pass data through the bus') {
  it('passes') {
    (env = ENV.clone)['RUBYOPT']='-Ilib'; ENV.stub('[]') {|x| env[x]}
    %x{#{Gem.ruby} ./bin/panoptimon -C sample_configs/passthru/ -D}.
      should == "ok\n"
  }
}
