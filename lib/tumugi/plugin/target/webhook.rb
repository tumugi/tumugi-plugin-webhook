require 'tumugi'

module Tumugi
  module Plugin
    class WebhookTarget < Tumugi::Target
      Tumugi::Plugin.register_target('webhook', self)

      attr_reader :value

      def initialize(value)
        @value = value
      end

      def exist?
        # TODO: Implemente this method
        true
      end
    end
  end
end
