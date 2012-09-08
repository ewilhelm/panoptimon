require 'panoptimon/http'

monitor.enable_cache
monitor.http.match('/', ->(env) {
  monitor.logger.debug "passed me #{env}"
  env['rack.logger'].debug "status page request for #{env['REMOTE_ADDR']}"
  # NOTE ^- is the same as monitor.logger

  [200, {'Content-Type' => 'text/html'}, [%Q{<html>
    <head><title>Panoptimon</title></head>
      <body>
        #{require "cgi"; CGI.escapeHTML(env.inspect)}
      </body>
  </html>}]]

})

return nil # no per-metric callback
