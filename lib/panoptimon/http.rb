require 'thin'

module Panoptimon
class HTTP

  def initialize (args={})
    # TODO args[:config].http_port, ssl, etc
    @http = Thin::Server.new('0.0.0.0', 8080, self);
    @http.backend.start
  end

  def call (env)
    return [200, {"Content-Type" => "text/html"}, [env.inspect]]
  end

  # exact-match
  def match (path, app)
  end

  # path prefix
  def mount (point, app)
  end

end
end
