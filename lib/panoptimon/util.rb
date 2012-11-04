module Panoptimon
  module Util
    VERSION = '0.0.1'

    def self.os (dispatch={})
      # TODO or mess with rbconfig + Config::CONFIG['host_os']
      @os ||= Gem::Platform.local.os
      return @os unless dispatch.length > 0

      it = dispatch[@os.to_sym] or raise "unsupported OS: #{@os}"
      return it.call()
    end

  end
end
