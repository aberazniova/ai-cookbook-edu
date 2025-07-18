module ConversationTurns
  class Create
    include Callable

    def initialize(message_content:, role:, conversation:)
      @message_content = message_content
      @role = role
      @conversation = conversation
    end

    def call
      conversation.conversation_turns.create!(
        role: role,
        text_content: message_content,
        payload: Chatbot::BuildPayload::SingleMessage.call(message: message_content, role: role.to_s)
      )
    end

    private

    attr_reader :message_content, :role, :conversation
  end
end
