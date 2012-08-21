require "logger"

module Panoptimon::Logger

  def logger
    Panoptimon::Logger.logger
  end

  def self.logger
    @logger ||= Logger.new($stderr).tap {|l|
      # TODO env setting log level?
      l.level = Logger::WARN}
  end

end
