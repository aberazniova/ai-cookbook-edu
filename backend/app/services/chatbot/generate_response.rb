module Chatbot
  class GenerateResponse
    include Callable

    def initialize(conversation:)
      @conversation = conversation
    end

    def call
      unless response_content.present?
        raise "No response content received"
      end

      save_response_turn

      if function_call.present?
        Chatbot::ProcessFunctionCall.call(
          function_call_name: function_call.dig("name"),
          function_call_args: function_call.dig("args"),
          conversation: conversation
        )
      else
        response_content.dig("text")
      end
    end

    private

    attr_reader :conversation

    def api_response
      @_api_response ||= ExternalApi::GoogleGemini.generate_content(conversation_contents)
    end

    def function_call
      return @_function_call if defined?(@_function_call)

      @_function_call = response_content.dig("functionCall")
    end

    def response_content
      @_response_content ||= api_response.dig("candidates", 0, "content", "parts", 0)
    end

    def save_response_turn
      ConversationTurns::CreateFromGeminiApiResponse.call(
        api_response: api_response,
        conversation: conversation
      )
    end

    def conversation_contents
      Chatbot::BuildPayload::ConversationHistory.call(conversation: conversation.reload)
    end
  end
end
