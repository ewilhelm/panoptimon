require 'erb'
require 'cgi'

start = Time.now
template = ERB.new <<EOT
<html>
  <head><title>Panoptimon</title></head>
  <body>
    running: <%= ((Time.now - start) / 60**2).round(2) %> hours
    <h1>Current Metrics</h1>
    <table border="1">
    <thead><tr><th>name</th><th>value</th></thead>
    <% m.cached.each do |k,v| %>
      <tr><td><%= CGI.escapeHTML(k) %></td>
          <td><%= CGI.escapeHTML(v.to_s) %></td></tr>
    <% end %>
    </table>
  </body>
</html>
EOT
render = ->(m) {
  template.result(binding)
}

monitor.enable_cache
monitor.http.match('/', ->(env) {
  monitor.logger.debug "passed me #{env}"
  env['rack.logger'].debug "status page request for #{env['REMOTE_ADDR']}"
  # NOTE ^- is the same as monitor.logger

  [200, {'Content-Type' => 'text/html'}, [render.call(monitor)]]

})

return nil # no per-metric callback
