module Panoptimon
class Monitor

  include Panoptimon::Logger

  attr_reader :config, :collectors, :plugins

  def initialize (args)
    @collectors = []
    args.each { |k,v| instance_variable_set("@#{k}", v) }

    me = self
    @bus = EM.spawn { |metric| me.bus_driver(metric) }
  end

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
        conf = JSON.parse(f.open.read, {:symbolize_names => true})
        base = f.basename.sub(/\.json$/, '').to_s
        command = conf[:exec] || base
        command = f.dirname + base + command unless command =~ /^\//
        name = conf[:name] || base
        logger.debug "command: #{command}"
        collector = Collector.new(
          name: name,
          bus: @bus,
          command: [command.to_s] + conf[:args].to_a,
          config: conf,
        )
        collectors << collector
      rescue => ex
        logger.error "collector #{f} failed to load: \n" +
          "  #{ex.message} \n  #{ex.backtrace[0]}"
      end
    }
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
    minterval = collectors.map{|c| c.interval}.min
    minterval = 60 if minterval.nil?
    logger.debug "minimum: #{minterval}"
    EM.add_periodic_timer(minterval, &runall);
  end

  def bus_driver(metric)
    logger.debug "metric: #{metric.inspect}"
  end

end
end
