module Chatbot
  class ProcessUserMessage
    include Callable

    Result = Struct.new(:success?, :response_message, :error)

    def initialize(message_content:)
      @message_content = message_content
    end

    def call
      create_conversation_turn

      result = Chatbot::GenerateResponseMessage.call(conversation_contents: conversation_contents)

      if result.success?
        Result.new(true, result.response_message, nil)
      else
        Result.new(false, nil, result.error)
      end
    end

    private

    attr_reader :message_content

    def create_conversation_turn
      ConversationTurns::Create.call(
        message_content: message_content,
        role: :user,
        conversation: conversation
      )
    end

    def conversation
      @_conversation ||= Conversation.last || Conversation.create! # TODO: Implement conversation retrieval based on the cookie
    end

    def conversation_contents
      Chatbot::BuildPayload::ConversationHistory.call(conversation: conversation)
    end
  end
end
