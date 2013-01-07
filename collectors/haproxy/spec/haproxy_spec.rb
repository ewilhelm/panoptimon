#!/usr/bin/env ruby

require 'rspec'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'panoptimon-collector-haproxy'

class TXSocket; attr_reader :readlines
  def puts (input); @readlines = @check[input]; end
  def initialize (check) ; @check = check; end
end

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
      ['/fakely', ->(input) {
        input.should == 'show stat'
        File.open(
          File.expand_path(__FILE__ + '-show_stat.csv')
        ).readlines
      }],
      ['/fakely', ->(input) {
        input.should == 'show info'
        File.open(
          File.expand_path(__FILE__ + '-show_info.txt')
        ).readlines
      }]
    ]
    require 'socket'; UNIXSocket.stub(:new) {|name|
      x = plan.shift
      name.should == x[0]
      TXSocket.new(x[1])
    }
    # TODO refactor this to run through self.info or something
    info = c.stats_from_sock('/fakely')
    info[:stats][:BACKEND]['qrstuv'][:status].should == 'UP'
    info[:info][:maxsock].should == 8018
    info[:info][:maxsock].class.should == Fixnum

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

}
