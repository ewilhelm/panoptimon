# Copyright (C) 2012 Sourcefire, Inc.

module Panoptimon
class Monitor

  include Panoptimon::Logger

  attr_reader :config, :collectors, :plugins, :cached, :owd,
    :loaded_plugins, :bus

  def initialize (args={})
    @collectors = []
    @plugins    = {}
    @loaded_plugins = {}
    args.each { |k,v| instance_variable_set("@#{k}", v) }

    @owd = Dir.pwd

    me = self
    @bus = EM.spawn { |metric| me.bus_driver(metric) }
  end

  # Search directories for JSON files
  def _dirjson (x)
    x = Pathname.new(x)
    x.entries.find_all {|f| f.to_s =~ /\.json$/i}.
      map {|f| x + f}
  end

  def find_collectors
    _dirjson(config.collectors_dir)
  end

  def find_plugins
    _dirjson(config.plugins_dir)
  end

  def load_collectors
    find_collectors.each {|f|
      begin
        _init_collector(_load_collector_config(f))
      rescue => ex
        logger.error "collector #{f} failed to load: \n" +
          "  #{ex.message} \n  #{ex.backtrace[0]}"
      end
    }
  end

  def _load_collector_config (file)
    conf = JSON.parse(file.read, {:symbolize_names => true})

    # Determine the command path
    collector_name = file.basename.sub(/\.json$/, '').to_s
    command = conf[:exec] ||= collector_name
    command = file.dirname + collector_name + command unless command =~ /^\//

    command = _autodetect_collector_command_path(collector_name) unless File.exists?(command) # TODO - not happy with this.

    # TODO - interval/timeout defaults should be configurable
    return conf.
      merge({
        name: collector_name,
        interval: (self.config.collector_interval || 99).to_i,
        timeout:  (self.config.collector_timeout || 99).to_i
      }) {|k,a,b| a}.
      merge({command: command})
  end

  # Searches for 'pancollect-' executables in $PATH
  # Returns nil if no command found
  def _autodetect_collector_command_path(name)
    pathdirs = ENV["PATH"].split(":")
    name = 'pancollect-' + name
    pathdirs.each{|basepath|
      path = File.join(basepath, name)
      logger.debug "checking path #{path}"
      return path if File.exists?(path)
    }
    return nil
  end

  def _init_collector (conf)
    name    = conf.delete(:name)
    command = conf.delete(:command)
    full_cmd = [command.to_s] + conf[:args].to_a
    logger.debug "#{name} command: #{full_cmd}"
    collector = Collector.new(
      name: name,
      bus: @bus,
      command: full_cmd,
      config: conf,
    )
    collectors << collector
  end

  def http
    return @http unless @http.nil?
    # TODO rescue LoadError => nicer error message
    require 'panoptimon/http'
    @http = HTTP.new
  end

  def empty_binding; binding; end
  def load_plugins
    find_plugins.each {|f| _init_plugin(_load_plugin_config(f)) }
  end

  def _load_plugin_config (file)
    conf = JSON.parse(file.read, {:symbolize_names => true})
    base = file.basename.sub(/\.json$/, '').to_s

    # TODO support conf[:require] -> class.setup(conf) scheme?
    rb = conf[:require] || "#{base}.rb"
    rb = file.dirname + base + rb
    return conf.
      merge({
        name: base,
      }) {|k,a,b| a}.
      merge({
        base: base,
        rb: rb
      })
  end

  def _init_plugin (conf)
    name = conf.delete(:name)
    rb   = conf.delete(:rb)
    setup = eval("->(name, config, monitor) {#{rb.open.read}\n}",
      empty_binding, rb.to_s, 1)
    callback = begin; setup.call(name, conf, self)
      rescue; raise "error loading plugin '#{name}' - #{$!}"; end
    logger.debug "plugin #{callback} - #{plugins[name]}"
    plugins[name] = callback unless callback.nil?
    loaded_plugins[name] = conf.clone # XXX need a plugin object?
  end

  def run

    runall = ->() {
      logger.debug "beep"
      collectors.each {|c|
        logger.info "#{c.cmd} (#{c.running? ? 'on ' : 'off'
          }) last run time: #{c.last_run_time}"
        next if c.last_run_time + c.interval > Time.now or c.running?
        c.run
      }
    }
    EM.next_tick(&runall)
    logger.warn 'no collectors' if collectors.length == 0
    minterval = collectors.map{|c| c.interval}.min
    minterval = 67 if minterval.nil? # XXX should never happen
    logger.debug "minimum: #{minterval}"
    EM.add_periodic_timer(minterval, &runall);

    @http.start if @http

  end

  def stop
    EM.stop
  end

  def enable_cache(arg=true);
    if arg; @cached ||= {}; else; @cached = nil; end
  end

  def bus_driver(metric)
    logger.debug {"metric: #{metric.inspect}"}
    metric.each {|k,v| @cached[k] = v} if @cached
    plugins.each {|n,p|
      begin p.call(metric)
      rescue => e
        logger.warn "plugin '#{n}' error: " +
          "#{e}\n  #{e.backtrace[0].sub(%r{^.*/?(plugins/)}, '\1')}"
        plugins.delete(n)
      end
    }
  end

end
end
