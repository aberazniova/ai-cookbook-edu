module Chatbot
  class ProcessUserMessage
    include Callable

    Result = Struct.new(:success?, :messages, :error)

    def initialize(message_content:, conversation:)
      @message_content = message_content
      @conversation = conversation
    end

    def call
      @user_message_turn = create_conversation_turn

      Chatbot::GenerateResponse.call(conversation: conversation)

      Result.new(true, new_messages, nil)
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

    def new_messages
      conversation.conversation_turns.displayable.where("id > ?", @user_message_turn.id)
    end
  end
end
