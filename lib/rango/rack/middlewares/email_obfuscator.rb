# encoding: utf-8

# TODO: it can be in rack-contrib
module Rango
  module Middlewares
    class EmailObfuscator
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        if headers["Content-Type"] == "text/html"
          body = self.substitute(body)
        end
        [status, headers, body]
      end

      # TODO: is it OK everywhere? E. g. <script> or <style>
      def substitute(body)
        body.map { |chunk| chunk.gsub!("@", "&#x40;") }
      end
    end
  end
end
