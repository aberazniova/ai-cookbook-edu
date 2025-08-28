module Chatbot
  module BuildPayload
    class ConversationHistory
      include Callable

      def initialize(conversation:)
        @conversation = conversation
      end

      def call
        conversation_turns
          .pluck(:payload)
      end

      private

      attr_reader :conversation

      def conversation_turns
        conversation.conversation_turns.order(:created_at)
      end
    end
  end
end
