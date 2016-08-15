require 'tumugi'
require 'faraday'
require 'faraday_middleware'
require 'uri'
require_relative '../webhook/logger'

module Tumugi
  module Plugin
    class WebhookTask < Tumugi::Task
      Tumugi::Plugin.register_task('webhook', self)

      METHODS = Set.new [:get, :post, :put, :delete, :head, :patch, :options]
      BODY_ENCODINGS = Set.new [ :url_encoded, :json ]

      param :url, type: :string, required: true
      param :http_method, type: :string, default: "post"
      param :body, type: :string
      param :body_encoding, type: :string, default: "json"

      def run
        validate_parameters!

        conn = Faraday.new(url: url) do |c|
          c.request :retry
          c.request body_encoding.downcase.to_sym
          c.response :follow_redirects
          c.response :webhook_logger, logger
          c.adapter Faraday.default_adapter
        end

        m = http_method.downcase.to_sym
        http_body = [:get, :head, :delete].include?(m) ? nil : body
        res = conn.run_request(m, nil, http_body, nil)

        if !res.success?
          raise Tumugi::TumugiError.new("HTTP request to #{uri} is failed: #{res.status} #{res.body}")
        end
      end

      private

      def validate_parameters!
        if !METHODS.include?(http_method.downcase.to_sym)
          raise Tumugi::TumugiError.new("Unknown http method: #{http_method}")
        end

        if !BODY_ENCODINGS.include?(body_encoding.downcase.to_sym)
          raise Tumugi::TumugiError.new("Unknown body encoding: #{body_encoding}")
        end
      end
    end
  end
end
