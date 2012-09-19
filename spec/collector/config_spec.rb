#!/usr/bin/env ruby

require 'panoptimon'

require 'pathname'

m = Panoptimon::Monitor.new(
  config: Panoptimon.load_options(['-c', '',
    '-o', 'collector_interval=9',
    '-o', 'collector_timeout=12',
  ])
)

conf = ->(content) {
  file = Pathname.new('blah/collectors/not.json')
  file.stub(:read) { content }
  OpenStruct.new(m._load_collector_config(file))
}

describe 'default config' do
  subject { conf.call( %{ {} } ) }
  its(:interval) {should == 9}
  its(:timeout) {should == 12}
end

describe 'override config' do
  subject { conf.call( %{ {"interval": 3, "timeout": 7} } ) }
  its(:interval) {should == 3}
  its(:timeout) {should == 7}
end
