level = config[:level] || 'debug'
->(metric) {
  monitor.logger.send(level) {'log_to_logger: ' + metric.inspect}
}
