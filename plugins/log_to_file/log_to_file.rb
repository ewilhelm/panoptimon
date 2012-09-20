require "json"
fh = File.new(config[:file] || raise("must have filename"), 'a')
->(metric) {
  # TODO handle failed writes / disk full?
  fh.puts "#{Time.now.to_i} #{JSON.generate(metric)}"
  # TODO flush on timer / only log once per second?
  fh.flush
}
