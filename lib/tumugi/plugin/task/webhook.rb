require 'tumugi'
require 'tumugi/plugin/file_system_target'
require 'faraday'
require 'faraday_middleware'
require 'uri'
require_relative '../webhook/logger'

module Tumugi
  module Plugin
    class WebhookTask < Tumugi::Task
      Tumugi::Plugin.register_task('webhook', self)

      METHODS = Set.new [:get, :post, :put, :delete]
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
        http_body = [:get, :delete].include?(m) ? nil : body
        begin
          res = conn.run_request(m, nil, http_body, nil)
          if !res.success?
            raise Tumugi::TumugiError.new("#{m} #{url} failed: #{res.status} #{res.body}")
          end
        rescue => e
          raise Tumugi::TumugiError.new("#{m} #{url} failed", e)
        end

        if _output && _output.is_a?(Tumugi::Plugin::FileSystemTarget)
          _output.open("w") do |f|
            f.write(res.body)
          end
        end
      end

      private

      def validate_parameters!
        if !METHODS.include?(http_method.downcase.to_sym)
          raise Tumugi::TumugiError.new("Unsupported http method: #{http_method}")
        end

        if !BODY_ENCODINGS.include?(body_encoding.downcase.to_sym)
          raise Tumugi::TumugiError.new("Unsupported body encoding: #{body_encoding}")
        end
      end
    end
  end
end
