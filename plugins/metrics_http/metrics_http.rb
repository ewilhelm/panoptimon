require "json"
monitor.enable_cache
monitor.http.mount('/metrics.json', ->(env) {
  metrics = monitor.cached
  match = env['PATH_INFO']
  match = (match.length == 0 || match == '/') ? nil :
    %r{^(?:#{
      match.sub(/^\//, '').split(/&/).map {|it|
        Regexp.escape(Rack::Utils.unescape(it))
      }.join('|')
    })(?:\||$)}
  json = JSON.generate(
    match ? metrics.select {|k,v| k =~ match} : metrics)
  [200, {'Content-Type' => 'text/json'}, [json]]
})

return nil
