#!/usr/bin/env ruby

require 'rspec'
require 'panoptimon-collector-socket'

describe('basic test') {
  it('works') {
    socket = Panoptimon::Collector::Socket::Unix.new(
      path:  '/tmp/sockpuppet',
      query: 'show info')
    socket.path.class.should == String
    socket.path.should =~ %r{^/\w+}
    socket.query.should == 'show info'

    yo = nil
    socket.stub(:get_banner) { yo = "foo\nbar\nbaz" }
    ans = socket.run
    yo.should == "foo\nbar\nbaz"
    ans[:status].should == true
  }
  it('does matching too') {
    socket = Panoptimon::Collector::Socket::Unix.new(
      path:  '/tmp/sockpuppet',
      query: 'show info',
      match: 'frobnosticate',
    )
    socket.path.class.should == String
    socket.path.should =~ %r{^/\w+}
    socket.query.should == 'show info'

    socket.stub(:get_banner) { "foo\nbar\nbaz" }
    ans = socket.run
    ans[:status].should == false
  }
}
