module Panoptimon

require 'json';

class Collector

  include Panoptimon::Logger

  attr_reader :name, :cmd, :config, :bus, :last_run_time, :interval
  def initialize (args)
    cmd = args.delete(:command) or raise "must have 'command' argument"
    @cmd = cmd.class == Array ? cmd : Shellwords.shellsplit(cmd)
    ->(exe) {
      raise "no such file '#{exe}'" unless File.exist?(exe)
      raise "command '#{exe}' is not executable" unless File.executable?(exe)
    }.call(@cmd[0]) # TODO or maybe args[:interpreter]
    @bus = args.delete(:bus) or raise "must have 'bus' argument"
    args.each { |k,v| instance_variable_set("@#{k}", v) }

    @name ||= 'unnamed'
    @config ||= {}

    @interval = config[:interval] ||= 60
    @last_run_time = Time.at(-@interval)
  end

  def run
    cmdc = @cmd + [JSON.generate(config)]

    @last_run_time = Time.now # TODO .to_i ?

    logger.info {"run command: #{cmdc}"}
    @child = EM.popen3b(cmdc, CollectorSink, self)
    @child.on_unbind { |status, errmess|
      logger.error {"collector #{name} failed: #{status}" +
        (errmess.nil? ? '' :
          "\n  #{errmess.chomp.split(/\n/).join("\n  ")}")
      } if(not(status.nil?) and status != 0)
      @child = nil
    }
    logger.debug "timeout is: #{config[:timeout]}"
    # XXX afaict, eventmachine just did not implement this:
    # @child.set_comm_inactivity_timeout(config[:timeout])
  end

  def noise(mess)
    logger.warn "collector/#{name} noise: #{mess.chomp}"
  end

  def running?
    @child.nil? ? false : true
  end

end

module CollectorSink

  def initialize (handler)
    @handler = handler
    @timeout = @handler.config[:timeout]
    @interval = @handler.config[:interval]
    timer_on
  end

  def _flatten_hash (i,p,h)
    h.each {|k,v|
      k = "#{p}|#{k}"
      if v.is_a?(Hash)
        _flatten_hash(i, k, v)
      else
        i[k] = v
      end
    }
    return i
  end

  # reset / start timeout timer
  def timer_on (opts={})
    @timer.cancel unless @timer.nil?
    length = @timeout + (opts[:with_interval] ? @interval : 0)
    @timer = EventMachine::Timer.new(length) {
      @handler.logger.error "timeout on #{@handler.name}"
      @handler.logger.debug {"pid #{get_pid}"}
      close_connection()
    }
  end

  def timer_off
    @timer.cancel
  end

  def receive_data (data)
    timer_on(with_interval: true)
    @handler.logger.debug "incoming"
    @buf ||= BufferedTokenizer.new("\n")
    @buf.extract(data).each do |line|
      begin
        data = JSON.parse(line)
      rescue
        # TODO feed errors up to the monitor
        $stderr.puts "error parsing #{line.dump} - #{$!}"
      end
      @handler.logger.debug "line: #{line}"
      @handler.bus.notify(_flatten_hash({}, @handler.name, data))
    end
  end

  def receive_stderr (mess)
    @handler.noise(mess)
    (@err_mess ||= '') << mess
  end

  def on_unbind (&block); @on_unbind = block; end
  def unbind
    timer_off
    @on_unbind.call(get_status.exitstatus, @err_mess)
  end

end

end

