module Chatbot
  class ProcessFunctionCall
    include Callable

    def initialize(function_call_name:, function_call_args:, conversation:)
      @function_call_name = function_call_name
      @function_call_args = function_call_args
      @conversation = conversation
    end

    def call
      result = process_based_on_function_call_name

      function_call_response = function_call_response(result)
      create_conversation_turn(function_call_response)

      Chatbot::GenerateResponse.call(conversation: conversation)
    end

    private

    attr_reader :function_call_name, :function_call_args, :conversation

    def process_based_on_function_call_name
      function_class = "Chatbot::FunctionCalls::#{function_call_name.camelize}".safe_constantize

      unless function_class
        raise StandardError, "Function call not supported: #{function_call_name}"
      end

      function_class.call(**symbolized_arguments, user: conversation.user)
    rescue StandardError => e
      {
        "status": "error",
        "message": e.message
      }
    end

    def function_call_response(result)
      {
        name: function_call_name,
        response: result
      }
    end

    def create_conversation_turn(function_call_response)
      ConversationTurns::CreateFromFunctionResponse.call(
        function_call_name: function_call_name,
        function_response_part: function_call_response,
        conversation: conversation
      )
    end

    def symbolized_arguments
      function_call_args.transform_keys(&:to_sym)
    end
  end
end
