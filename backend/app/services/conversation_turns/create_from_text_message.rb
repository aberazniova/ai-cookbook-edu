module ConversationTurns
  class CreateFromTextMessage
    include Callable

    def initialize(message_content:, conversation:, role:)
      @message_content = message_content
      @conversation = conversation
      @role = role
    end

    def call
      ConversationTurns::Create.call(
        role: role,
        message_content: message_content,
        payload: Chatbot::BuildPayload::SingleTurn.call(role: role.to_s, parts: [{ text: message_content }]),
        conversation: conversation
      )
    end

    private

    attr_reader :message_content, :conversation, :role
  end
end
