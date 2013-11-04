#!/usr/bin/env ruby

require 'rspec'
require 'panoptimon'

describe('flatten a metric') {
  it('flattens metrics') {
    Panoptimon::Metric.new('x', {'t' => {'q' => 9, 'r' => 7.3}}).
      should == {'x|t|q' => 9, 'x|t|r' => 7.3}
  }
  it('does not mangle _info entries') {
    Panoptimon::Metric.new('x', {'t' => {'q' => 9, 'r' => 7.3},
      '_info' => {
        'keys' => 'arbitrary values',
        'whatever' => ['deep structure', 'blah', {'blah' => 'blah'}]}
      }).
      should == {'x|t|q' => 9, 'x|t|r' => 7.3, 'x|_info' => {
        'keys' => 'arbitrary values',
        'whatever' => ['deep structure', 'blah', {'blah' => 'blah'}]
      }}
  }
  it('returns empty hash when there is no metrics') {
    Panoptimon::Metric.new('blanks', {}).
      should == {}
  }
}
