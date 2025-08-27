module Chatbot
  class ProcessUserMessage
    include Callable

    Result = Struct.new(:success?, :response_message, :error)

    def initialize(message_content:, conversation:)
      @message_content = message_content
      @conversation = conversation
    end

    def call
      create_conversation_turn

      gemini_response = Chatbot::GenerateResponse.call(conversation: conversation)

      Result.new(true, gemini_response, nil)
    rescue StandardError => e
      Rails.logger.error("Error generating chatbot response: #{e.message}")
      Result.new(false, nil, e.message)
    end

    private

    attr_reader :message_content, :conversation

    def create_conversation_turn
      ConversationTurns::CreateFromTextMessage.call(
        message_content: message_content,
        conversation: conversation,
        role: :user
      )
    end
  end
end
