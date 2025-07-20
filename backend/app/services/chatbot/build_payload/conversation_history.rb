module Chatbot
  module BuildPayload
    class ConversationHistory
      include Callable

      def initialize(conversation:)
        @conversation = conversation
      end

      def call
        # We need to get the most recent turns, but pass them to gemini from oldest to newest
        conversation_turns
          .order(created_at: :asc)
          .offset([conversation_turns.count - max_history_length, 0].max)
          .map(&:payload)
      end

      private

      attr_reader :conversation

      # This limit exists for minimizing Gemini API token usage
      def max_history_length
        ENV.fetch("GEMINI_API_MAX_HISTORY_LENGTH", 10).to_i
      end

      def conversation_turns
        conversation.conversation_turns
      end
    end
  end
end
