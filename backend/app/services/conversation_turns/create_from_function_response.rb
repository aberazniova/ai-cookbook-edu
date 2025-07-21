module ConversationTurns
  class CreateFromFunctionResponse
    include Callable

    def initialize(function_call_name:, function_response_part:, conversation:)
      @function_call_name = function_call_name
      @function_response_part = function_response_part
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

    attr_reader :function_call_name, :function_response_part, :conversation

    def role
      :user
    end

    def payload
      Chatbot::BuildPayload::SingleTurn.call(
        role: role.to_s,
        parts: [{ functionResponse: function_response_part }]
      )
    end
  end
end
