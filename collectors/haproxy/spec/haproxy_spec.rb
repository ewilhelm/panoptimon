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
    c.send(:new).tap {|me|
      me.collector.should == :stats_from_sock
      me.stats_url.should == '/var/run/haproxy.sock'
    }
  }
  it('automatically assumes a socket (with argument)') {
    c.send(:new, stats_url: "/var/lib/haproxy.sock").tap {|me|
      me.collector.should == :stats_from_sock
      me.stats_url.should == '/var/lib/haproxy.sock'
    }
  }
  it('takes explicit socket:// too') {
    c.send(:new, stats_url: "socket://var/lib/haproxy.sock").tap {|me|
      me.collector.should == :stats_from_sock
      me.stats_url.should == '/var/lib/haproxy.sock'
    }
  }
  it('knows when you said otherwise') {
    c.send(:new, stats_url: "sprocket://var/lib/haproxy.sock").tap {|me|
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
    puts info.inspect

  }
}
