level = config[:level] || 'debug'
->(metric) {
  monitor.logger.send(level) {
    (config[:prefix] || '') +
    (config[:json] ? JSON::generate(metric) : metric.inspect)
  }
}
