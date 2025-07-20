module ConversationTurns
  class Create
    include Callable

    def initialize(role:, payload:, conversation:, message_content: nil)
      @message_content = message_content
      @role = role
      @payload = payload
      @conversation = conversation
    end

    def call
      conversation.conversation_turns.create!(
        role: role,
        text_content: message_content,
        payload: payload
      )
    end

    private

    attr_reader :message_content, :role, :conversation, :payload
  end
end
