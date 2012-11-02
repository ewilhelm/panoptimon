#!/usr/bin/env ruby

require 'rspec'
require 'panoptimon'

describe('collector exec must exist') {
  this = ->(setup) {
    setup.call()
    Panoptimon::Collector.new(
      command: ['nosuchfilehere'],
      bus: not(nil)
    );
  }
  it('complains if command file does not exist') {
    expect {this.call(->(){})}.
      to raise_exception(/no such file/)
  }

  it('complains if command file is not executable') {
    expect {this.call(->(){File.stub('exist?') {true}})}.
      to raise_exception(/is not executable/)
  }

}
