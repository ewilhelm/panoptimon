#!/usr/bin/env ruby

require 'panoptimon/util'
require 'ostruct'

describe('os lookup string') {
  before(:each) {
    Panoptimon::Util.stub(:_os) { :plan9 }
  }
  it('returns correct string') {
    Panoptimon::Util.os.should == :plan9
  }
  it('returns correct hash value') {
    Panoptimon::Util.os(plan9: 10, default: 0).should == 10
    Panoptimon::Util.os(win32: 'twelve', plan9: 10, default: 0).should == 10
  }
  it('falls-through to a default') {
    Panoptimon::Util.os(default: 'ok').should == 'ok'
  }
  it('dispatches to a proc') {
    Panoptimon::Util.os(plan9: ->(){7}, default: 0).should == 7
  }
  it('dispatches to a default proc') {
    Panoptimon::Util.os(default: ->(){'ok'}).should == 'ok'
  }
  it('complains loudly if needed') {
    expect {
      Panoptimon::Util.os(linux: 7)
    }.to raise_exception(/^unsupported OS/)
  }
  it('can complain selectively') {
    expect {
      Panoptimon::Util.os(plan9: ->(){raise "unsupported OS: plan9"}, default: 'ok')
    }.to raise_exception(/^unsupported OS/)
  }
}

