module ConversationTurns
  class CreateFromGeminiApiResponse
    include Callable

    def initialize(api_response:, conversation:)
      @api_response = api_response
      @conversation = conversation
    end

    def call
      ConversationTurns::Create.call(
        message_content: message_content,
        role: role,
        payload: turn_payload,
        conversation: conversation
      )
    end

    private

    attr_reader :api_response, :conversation

    def message_content
      responded_with_function_call? ? nil : api_response.dig("candidates", 0, "content", "parts", 0, "text")
    end

    def role
      responded_with_function_call? ? :function : :model
    end

    def responded_with_function_call?
      @_responded_with_function_call ||= api_response.dig("candidates", 0, "content", "parts", 0, "functionCall").present?
    end

    def turn_payload
      full_content = api_response.dig("candidates", 0, "content")

      # Remove thoughtSignature as we don't need to pass it to Gemini with history
      modified_parts = full_content["parts"].map { |part| part.except("thoughtSignature") }

      full_content.merge("parts" => modified_parts)
    end
  end
end
