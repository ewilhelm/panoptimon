require 'thin'

module Panoptimon
class HTTP

  include Logger

  def initialize (args={})
    @match = []
    @mount = []
    # TODO args[:config].http_port, ssl, etc
    @http = Thin::Server.new('0.0.0.0', 8080, self);
  end

  def start
    @http.backend.start
  end

  def call (env)
    path = env['PATH_INFO']
    return favicon(env) if path == '/favicon.ico'
    # logger.debug { "#{path} => " + env.inspect }
    if    go = @match.find {|x| path =~ x[0]}
    elsif go = @mount.find {|x| path =~ %r{^#{x[0]}(/|$)}}
      env['SCRIPT_NAME'] = go[0]
      env['PATH_INFO'] = path.sub(%r{^#{go[0]}}, '')
    else
      return [404, {'Content-Type' => 'text/html'},
        '<html><head><title>Not Found</title></head>' +
        '<body><p>nope</p></body></html>']
    end
    env['rack.logger'] = logger
    return go[1].call(env)
  end

  def favicon(env)
    # TODO bundle / configure favicon?
    # NOTE why doesn't rack/thin support .to_path per spec?
    return [200, {'Content-Type' => 'image/x-icon'},
      Pathname.new('/tmp/favicon.ico').open]
  end

  # regexp-match
  def match (regexp, app)
    regexp = %r{^#{regexp}} if regexp.class == String
    @match.push([regexp, app])
  end

  # path prefix
  def mount (point, app)
    point.sub(%r{/*$})
    @mount.push([point, app])
  end

end
end
