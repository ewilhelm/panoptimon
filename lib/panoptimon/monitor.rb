module Panoptimon
class Monitor

  include Panoptimon::Logger

  attr_reader :config, :collectors, :plugins

  def initialize (args)
    @collectors = []
    args.each { |k,v| instance_variable_set("@#{k}", v) }

    @bus = EM.spawn { |metric|
      logger.debug "metric: #{metric.inspect}"
    }
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

end
end
