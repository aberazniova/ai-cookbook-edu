module Chatbot
  module BuildPayload
    class ConversationHistory
      include Callable

      def initialize(conversation:)
        @conversation = conversation
      end

      def call
        conversation.conversation_turns.order(created_at: :asc).map(&:payload)
      end

      private

      attr_reader :conversation
    end
  end
end
