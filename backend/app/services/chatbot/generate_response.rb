module Chatbot
  class GenerateResponse
    include Callable

    def call
      return if parts.empty?

      response_turn = save_response_turn

      if function_call.present?
        Chatbot::ProcessFunctionCall.call(
          function_call_name: function_call.dig("name"),
          function_call_args: function_call.dig("args")
        )
      end
    end

    private

    def api_response
      @_api_response ||= ExternalApi::GoogleGemini.generate_content(conversation_contents)
    end

    def function_call
      return @_function_call if defined?(@_function_call)

      @_function_call = parts.filter_map { |p| p["functionCall"] }.first
    end

    def parts
      @_parts ||= response_content&.dig("parts") || []
    end

    def response_content
      @_response_content ||= api_response.dig("candidates", 0, "content")
    end

    def save_response_turn
      ConversationTurns::CreateFromResponsePayload.call(
        response_payload: response_content,
        conversation: conversation
      )
    end

    def conversation_contents
      Chatbot::BuildPayload::ConversationHistory.call(conversation: conversation)
    end

    def conversation
      Current.conversation
    end
  end
end
