# Copyright (C) 2012 Sourcefire, Inc.

module Panoptimon
  module Util
    VERSION = '0.0.1'

    def self._os; @os ||= Gem::Platform.local.os.to_sym; end

    # return osname
    # or, given a hash, return the corresponding hash element and raise
    # error if os not in hash keys
    def self.os (dispatch={})
      # TODO or mess with rbconfig + Config::CONFIG['host_os']
      os = _os
      return os unless dispatch.length > 0

      # experimental - skip detection and use specified name
      os = dispatch['-option'][:os_override].to_sym if
        dispatch['-option'] and dispatch['-option'][:os_override]

      it = dispatch[os] || dispatch[:default] or
        raise "unsupported OS: #{os}"
      return it.is_a?(Proc) ? it.call() : it
    end

  end
end
