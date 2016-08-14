require 'tumugi'
require 'tumugi/plugin/target/webhook'

module Tumugi
  module Plugin
    class WebhookTask < Tumugi::Task
      Tumugi::Plugin.register_task('webhook', self)

      param :param1, type: :string, required: true
      param :param2, type: :integer, default: 1

      def output
        @output ||= Tumugi::Plugin::WebhookTarget.new(param1)
      end

      def run
        # TODO: Implemente this method
        log "run #{self.class.name}"
        log "param1: #{param1}"
      end
    end
  end
end
