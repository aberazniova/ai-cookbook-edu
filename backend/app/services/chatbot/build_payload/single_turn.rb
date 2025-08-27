module Chatbot
  module BuildPayload
    class SingleTurn
      include Callable

      def initialize(role:, parts:)
        @role = role
        @parts = parts
      end

      def call
        {
          role: role,
          parts: parts
        }
      end

      private

      attr_reader :role, :parts
    end
  end
end
