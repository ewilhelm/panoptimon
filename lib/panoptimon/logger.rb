# Copyright (C) 2012 Sourcefire, Inc.

require "logger"

module Panoptimon::Logger

  def logger
    Panoptimon::Logger.logger
  end

  def self.logger
    @logger ||= Logger.new($stderr).tap {|l|
      env_l = ENV.delete('LOG_LEVEL')
      l.level = env_l.nil? ?
        Logger::WARN : Logger.const_get(env_l.upcase)
    }
  end

end
