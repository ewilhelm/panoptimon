#!/usr/bin/env ruby

require 'panoptimon'

describe('pass data through the bus') {
  it('passes') {
    (env = ENV.clone)['RUBYOPT']='-Ilib'; ENV.stub('[]') {|x| env[x]}
    IO.popen([Gem.ruby, './bin/panoptimon', '-D',
        '-C', 'sample_configs/passthru/'],
      'r', {'RUBYOPT' => '-Ilib'}
    ).readlines.should == ["ok\n"]
  }
}
