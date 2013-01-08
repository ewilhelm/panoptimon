$:.unshift File.expand_path('../lib')
require 'panoptimon-collector-socket'
require 'minitest/autorun'

class TestPanoptimonCollectorSocketUnix < MiniTest::Unit::TestCase
  def setup
    @socket = Panoptimon::Collector::Socket::Unix.new(
      :path    => '/var/run/haproxy.sock',
      :timeout => '5',
      :query   => 'show info')
  end

  def test_input_type
	assert_instance_of String, @socket.path
  end

  def test_valid_unix_path
    assert_match /(\/\w+\/)+/, @socket.path
  end

  def test_valid_output
	assert_instance_of Hash, @socket.run
  end
end
