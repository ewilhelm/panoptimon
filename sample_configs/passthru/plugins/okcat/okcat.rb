
require 'json'
expect = JSON.parse(File.new('sample_configs/passthru/collectors/cat/collect_this.json').read)
expect.keys.each {|k| expect['cat|'+k] = expect.delete(k)}
expect = JSON.generate(expect)
return ->(m) {
  return if m['beep|beep'] # TODO complain if it beeps twice
  monitor.logger.debug expect
  monitor.logger.debug { JSON.generate(m) }
  if JSON.generate(m) == expect
    puts 'ok'
    monitor.stop
  else
    puts 'not ok'
  end
}

