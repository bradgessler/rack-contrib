# When HA Proxy requests the HTTP_CHCK method, reply with an empty 200 OK
module Rack
  class Ping
    def initialize(app)
      @app = app
    end
    
    def call(env)
      if env['REQUEST_METHOD'] == 'PING'
        [ 200, {'Content-Type' => 'text/html', 'Content-Lenght' => '0'}, '' ]
      else
        @app.call(env)
      end
    end
  end
end