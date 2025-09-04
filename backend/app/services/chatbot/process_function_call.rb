module Chatbot
  class ProcessFunctionCall
    include Callable

    def initialize(function_call_name:, function_call_args:)
      @function_call_name = function_call_name
      @function_call_args = function_call_args
    end

    def call
      unless function_supported?
        raise StandardError, "Function call not supported: #{function_call_name}"
      end

      function_service.call(**symbolized_arguments, user: conversation.user)
    rescue StandardError => error
      Rails.logger.error("Error processing function call #{function_call_name}: #{error.message}")

      Chatbot::BuildPayload::FunctionResponsePart.call(
        function_call_name: function_call_name,
        status: "error",
        message: error.message
      )
    end

    private

    attr_reader :function_call_name, :function_call_args

    def function_supported?
      function_service.present?
    end

    def function_service
      "Chatbot::FunctionCalls::#{function_call_name.camelize}".safe_constantize
    end

    def symbolized_arguments
      function_call_args.transform_keys(&:to_sym)
    end

    def conversation
      Current.conversation
    end
  end
end
