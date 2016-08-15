require 'faraday'
require 'json'

module Tumugi
  module Plugin
    module Webhook
      class Logger < Faraday::Response::Middleware
        attr_reader :logger

        def initialize(app, logger)
          super(app)
          @logger = logger
        end

        def call(env)
          logger.info { "#{env[:method].upcase} #{env[:url]}" }
          log_request(env)
          super
        end

        def on_complete(env)
          status = env[:status]
          log_response_status(status) { "HTTP #{status}" }
          log_response(env)
        end

        def log_request(env)
          log(env[:request_headers], env[:body])
        end

        def log_response(env)
          log(env[:response_headers], env[:body])
        end

        def log(headers, body)
          logger.debug {
            JSON.generate(
              headers: headers,
              body: body
            )
          }
        end

        def log_response_status(status, &block)
          case status
          when 200..399
            logger.info(&block)
          else
            logger.error(&block)
          end
        end
      end
    end
  end
end

Faraday::Response.register_middleware({
  webhook_logger: Tumugi::Plugin::Webhook::Logger
})
