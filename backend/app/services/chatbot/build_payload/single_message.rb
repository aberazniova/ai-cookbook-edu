module Chatbot
  module BuildPayload
    class SingleMessage
      include Callable

      def initialize(message:, role:)
        @message = message
        @role = role
      end

      def call
        {
          "role": role,
          "parts": [
            { "text": message }
          ]
        }
      end

      private

      attr_reader :message, :role
    end
  end
end
