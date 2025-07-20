module Chatbot
  class GenerateResponseMessage
    include Callable

    Result = Struct.new(:success?, :response_message, :error)

    def initialize(conversation_contents:, conversation:)
      @conversation_contents = conversation_contents
      @conversation = conversation
    end

    def call
      Result.new(true, generate_response, nil)
    rescue StandardError => e
      Rails.logger.error("Error generating chatbot response: #{e.message}")
      Result.new(false, nil, e.message)
    end

    private

    attr_reader :conversation_contents, :conversation

    def generate_response
      unless response_content.present?
        raise "No response content received"
      end

      save_response_turn

      if function_call.present?
        Chatbot::ProcessFunctionCall.call(
          function_call_name: function_call.dig("name"),
          function_call_args: function_call.dig("args")
        )
      else
        response_content.dig("text")
      end
    end

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
  end
end
