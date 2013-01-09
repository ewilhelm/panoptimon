#!/usr/bin/env ruby

require 'rspec'
require 'panoptimon-collector-socket'

describe('basic test') {
  it('works') {
    socket = Panoptimon::Collector::Socket::TCP.new(
      path:  'localhost',
      port:  22,
      match: 'SSH'
    )
    socket.host.should == 'localhost'
    socket.port.should == 22
    socket.match.should == 'SSH'
    ans = socket.run
    ans.class.should == Hash
    ans[:status].should == true
  }
}

