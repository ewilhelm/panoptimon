require 'erb'
require 'cgi'

start = Time.now
template = ERB.new <<EOT
<html>
  <head><title>Panoptimon</title></head>
  <body>
    <p>
    <%= Time.now %> - running: <%= ((Time.now - start) / 60**2).round(2) %> hours
    (<%= (%x{ps -o rss= -p #{Process.pid}}.to_f/1024).round(2) %> MB)
    </p>

    <h1>Config</h1>
    <p><%= CGI.escapeHTML(JSON.pretty_generate(m.config.marshal_dump)).
      gsub(/\n  /, '<br>&nbsp;&nbsp;').sub(/\n}/, '<br>}') %></p>

    <h1>Plugins</h1>
    <table style="padding:1">
    <% m.loaded_plugins.each do |k,v| %>
      <tr><td><%= CGI.escapeHTML(k) %></td>
        <td><%= CGI.escapeHTML(JSON.generate(v)) %></td></tr></tr>
    <% end %>
    </table>

    <h1>Collectors</h1>
    <table style="padding:3">
    <% m.collectors.each do |c| %>
      <tr><td><%= CGI.escapeHTML(c.name) %></td>
        <td><%= CGI.escapeHTML(JSON.generate(c.config)) %></td>
        <td><%= c.last_run_time %></tr>
    <% end %>
    </table>

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
monitor.http.match('/$', ->(env) {
  monitor.logger.debug "passed me #{env}"
  env['rack.logger'].debug "status page request for #{env['REMOTE_ADDR']}"
  # NOTE ^- is the same as monitor.logger

  [200, {'Content-Type' => 'text/html'}, [render.call(monitor)]]

})

return nil # no per-metric callback
