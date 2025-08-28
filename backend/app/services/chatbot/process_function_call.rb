module Chatbot
  class ProcessFunctionCall
    include Callable

    def initialize(function_call_name:, function_call_args:, conversation:)
      @function_call_name = function_call_name
      @function_call_args = function_call_args
      @conversation = conversation
    end

    def call
      @function_call_result = process_based_on_function_call_name
      create_conversation_turn

      Chatbot::GenerateResponse.call(conversation: conversation)
    end

    private

    attr_reader :function_call_name, :function_call_args, :conversation

    def process_based_on_function_call_name
      unless function_supported?
        raise StandardError, "Function call not supported: #{function_call_name}"
      end

      function_service.call(**symbolized_arguments, user: conversation.user)
    rescue StandardError => error
      Rails.logger.error("Error processing function call #{function_call_name}: #{error.message}")

      {
        status: "error",
        message: error.message
      }
    end

    def function_supported?
      function_service.present?
    end

    def function_service
      "Chatbot::FunctionCalls::#{function_call_name.camelize}".safe_constantize
    end

    def symbolized_arguments
      function_call_args.transform_keys(&:to_sym)
    end

    def create_conversation_turn
      ConversationTurns::CreateFromFunctionResponse.call(
        function_call_name: function_call_name,
        function_response_part: build_function_call_response,
        conversation: conversation
      )
    end

    def build_function_call_response
      {
        name: function_call_name,
        response: @function_call_result
      }
    end
  end
end
