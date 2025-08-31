module Chatbot
  class ProcessUserMessage
    include Callable

    Result = Struct.new(:success?, :messages, :artifacts, :error)

    def initialize(message_content:)
      @message_content = message_content
    end

    def call
      @user_message_turn = create_conversation_turn

      Chatbot::GenerateResponse.call

      Result.new(true, new_messages, artifacts, nil)
    rescue StandardError => e
      Rails.logger.error("Error generating chatbot response: #{e.message}")
      Result.new(false, nil, nil, e.message)
    end

    private

    attr_reader :message_content, :user_message_turn

    def create_conversation_turn
      ConversationTurns::CreateFromTextMessage.call(
        message_content: message_content,
        conversation: conversation,
        role: :user
      )
    end

    def new_messages
      conversation.conversation_turns.displayable.where("conversation_turns.id > ?", user_message_turn.id)
    end

    def artifacts
      Current.artifacts ||= []
    end

    def conversation
      Current.conversation
    end
  end
end
