module ConversationTurns
  class CreateFromRawParts
    include Callable

    def initialize(parts:, role:, conversation:)
      @parts = parts
      @role = role
      @conversation = conversation
    end

    def call
      ConversationTurns::Create.call(
        role: role,
        payload: payload,
        conversation: conversation
      )
    end

    private

    attr_reader :parts, :role, :conversation

    def payload
      Chatbot::BuildPayload::SingleTurn.call(
        role: role.to_s,
        parts: parts
      )
    end
  end
end
