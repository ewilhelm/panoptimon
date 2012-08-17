module Panoptimon

require 'json';

class Collector

  attr_reader :cmd, :config, :bus
  def initialize(bus, cmd, config = {})
    (@cmd, @config, @bus) = cmd, config, bus
  end

  def run
    # TODO always append config to arguments vs not / .sub?
    cmd = "#{@cmd} '#{JSON.generate(config)}'"

    # puts "command: #{cmd}" # TODO logging
    (@child = EM.popen3(cmd, CollectorSink, self)
    ).on_unbind { @child = nil }
  end

  def is_running?
    @child.nil? ? false : true
  end

end

module CollectorSink

  def initialize (handler)
    @handler = handler
  end

  def receive_data data
    puts "incoming"
    @buf ||= BufferedTokenizer.new("\n")
    @buf.extract(data).each do |line|
      # TODO 1. assume each line is a parsable json chunk?
      #      2. feed back to monitor object: bus.notify(msg)
      puts "line: #{line}"
      @handler.bus.notify(line)
    end
  end

  def receive_stderr mess
    puts "stderr noise #{mess}"
    (@err_mess ||= '') << mess
  end

  def on_unbind (&block); @on_unbind = block; end
  def unbind
    puts "unbind #{get_status.exitstatus}"
    @on_unbind.call
  end

end

end

