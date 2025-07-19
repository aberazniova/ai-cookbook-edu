module Chatbot
  module BuildPayload
    class ConversationHistory
      include Callable

      def initialize(conversation:)
        @conversation = conversation
      end

      def call
        conversation.conversation_turns.order(created_at: :asc).limit(max_history_length).map(&:payload)
      end

      private

      attr_reader :conversation

      # This limit exists for minimizing Gemini API token usage
      def max_history_length
        ENV.fetch("GEMINI_API_MAX_HISTORY_LENGTH", 10).to_i
      end
    end
  end
end
