$:.unshift File.expand_path('../lib')
require 'rubygems'
require 'minitest/spec'
require 'minitest/autorun'
require 'panoptimon-collector-socket'

class TestPanoptimonCollectorSocketTCP < MiniTest::Unit::TestCase
  def setup
    @socket = Panoptimon::Collector::Socket::TCP.new(:path  => 'http://cloudysunday.com',
                                                     :port  => '22',
                                                     :match => 'SSH')
  end

  def test_valid_path
    assert_equal 'cloudysunday.com', @socket.host
  end

  def test_valid_port
    assert_equal '22', @socket.port
  end

  def test_valid_match
    assert_equal 'SSH', @socket.match
  end

  def test_valid_output
    assert_instance_of Hash, @socket.run
  end
end

