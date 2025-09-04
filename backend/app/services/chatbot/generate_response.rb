module Chatbot
  class GenerateResponse
    include Callable

    def call
      unless response_content.present?
        Rails.logger.warn("No content returned from Gemini.\n Api response: #{api_response}.\n Conversation id: #{conversation.id}")
        raise "The model encountered an internal failure while generating a response."
      end

      return if parts.empty?

      save_response_turn

      if function_calls.any?
        Chatbot::ProcessFunctionCalls.call(function_calls: function_calls)
      end
    end

    private

    def api_response
      @_api_response ||= ExternalApi::GoogleGemini.generate_content(conversation_contents)
    end

    def function_calls
      @_function_calls ||= parts.filter_map { |p| p["functionCall"] }
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
