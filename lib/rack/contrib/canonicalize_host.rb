module Rack
  # Canonicalizes host names to one specific host. This is great for situations where
  # you may want to redirect www.hostname.com to hostname.com.
  class CanonicalizeHost
    attr_accessor :hosts, :canonical_host
    
    def initialize(app,canonical_host,&block)
      @app, @canonical_host, @hosts = app, canonical_host, []
      instance_eval(&block) if block_given?
    end
    
    def from(host)
      @hosts << host
    end
    
    def call(env)
      req = Rack::Request.new(env)
      if req.host != canonical_host and hosts.include? req.host
        canonical_url = "#{req.scheme}://#{canonical_host}#{":#{req.port}" unless req.port == '80'}#{req.fullpath}"
        [302, {'Content-Type' => 'text/html', 'Location' => canonical_url}, %(Redirecting to <a href="#{canonical_url}">#{canonical_url}</a>...)]
      else
        @app.call(env)
      end
    end
  end
end