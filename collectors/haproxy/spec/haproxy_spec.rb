#!/usr/bin/env ruby

require 'rspec'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'panoptimon-collector-haproxy'

describe('socket usage') {
  c = Panoptimon::Collector::HAProxy
  it('automatically assumes a socket') {
    c.new().tap {|me|
      me.collector.should == :stats_from_sock
      me.stats_url.should == '/var/run/haproxy.sock'
    }
  }
  it('automatically assumes a socket (with argument)') {
    c.new(stats_url: "/var/lib/haproxy.sock").tap {|me|
      me.collector.should == :stats_from_sock
      me.stats_url.should == '/var/lib/haproxy.sock'
    }
  }
  it('takes explicit socket:// too') {
    c.new(stats_url: "socket://var/lib/haproxy.sock").tap {|me|
      me.collector.should == :stats_from_sock
      me.stats_url.should == '/var/lib/haproxy.sock'
    }
  }
  it('knows when you said otherwise') {
    c.new(stats_url: "sprocket://var/lib/haproxy.sock").tap {|me|
      me.collector.should_not == :stats_from_sock
    }
  }

  it('connects and such') {

    plan = [
      ['show stat', '-show_stat.csv'],
      ['show info', '-show_info.txt'],
    ]
    c.stub(:_sock_get) {|path, cmd|
      x = plan.shift
      cmd.should == x[0]
      File.open(File.expand_path(__FILE__ + x[1])).
        readlines
    }
    # TODO refactor this to run through self.info or something
    info = c.stats_from_sock('/fakely')
    info[:stats][:BACKEND]['qrstuv'][:status].should == 'UP'
    info[:info][:maxsock].should == 8018
    info[:info][:maxsock].class.should == Fixnum
    info[:info][:tasks].should == 6

  }
}

describe('http usage') {
  c = Panoptimon::Collector::HAProxy
  it('recognizes url') {
    c.new(stats_url: 'http://localhost:8080').tap {|me|
      me.collector.should == :stats_from_http
      me.stats_url.should == 'http://localhost:8080/'
    }
  }

  it('recognizes https url') {
    c.new(stats_url: 'https://localhost:8080').tap {|me|
      me.collector.should == :stats_from_http
      me.stats_url.should == 'https://localhost:8080/'
    }
  }

  it('does not mangle path') {
    c.new(stats_url: 'http://localhost:8080/bob').tap {|me|
      me.collector.should == :stats_from_http
      me.stats_url.should == 'http://localhost:8080/bob'
    }
  }

  it('connects and such') {
    plan = [
      ['http://localhost:8080/;csv', '-show_stat.csv'],
      ['http://localhost:8080/', '-get.html'],
    ]
    c.stub(:_http_get) {|uri|
      x = plan.shift
      uri.should == x[0]
      File.open(File.expand_path(__FILE__ + x[1])).
        readlines.join('')
    }

    info = c.stats_from_http('http://localhost:8080/')
    info[:stats][:BACKEND]['qrstuv'][:status].should == 'UP'
    info[:info][:maxsock].should == 8018
    info[:info][:maxsock].class.should == Fixnum
    info[:info][:tasks].should == 17
  }

}
