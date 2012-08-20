require "logger"

module Panoptimon::Logger

  def logger
    @logger ||= Logger.new($stderr).tap {|l|
      # TODO env setting log level?
      l.level = Logger::WARN}
  end

end
