module Panoptimon
class Monitor

  include Panoptimon::Logger

  attr_reader :config, :collectors, :plugins

  def initialize (args)
    @collectors = []
    args.each { |k,v| instance_variable_set("@#{k}", v) }
    logger.level = ::Logger::DEBUG
  end

  def _dirjson (x)
    Pathname.new(x).entries.find_all {|f| f.to_s =~ /\.json$/i}
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
      logger.info "beep"
      collectors.each {|c|
        logger.info "run time: #{c.last_run_time}"
        next if c.last_run_time + c.interval > Time.now or c.running?
        logger.info "run #{c.cmd}"
        c.run
      }
    }
    EM.next_tick(&runall)
    minterval = 60 # XXX collectors.map{|c| c.interval}.min
    EM.add_periodic_timer(minterval, &runall);
  end

end
end
