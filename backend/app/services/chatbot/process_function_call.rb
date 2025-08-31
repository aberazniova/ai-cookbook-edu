module Chatbot
  class ProcessFunctionCall
    include Callable

    def initialize(function_call_name:, function_call_args:)
      @function_call_name = function_call_name
      @function_call_args = function_call_args
    end

    def call
      process_based_on_function_call_name

      Chatbot::GenerateResponse.call
    end

    private

    attr_reader :function_call_name, :function_call_args

    def process_based_on_function_call_name
      unless function_supported?
        raise StandardError, "Function call not supported: #{function_call_name}"
      end

      function_service.call(**symbolized_arguments, user: conversation.user)
    rescue StandardError => error
      Rails.logger.error("Error processing function call #{function_call_name}: #{error.message}")
      save_failure_function_call_result(error.message)
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

    def save_failure_function_call_result(error_message)
      Chatbot::SaveFunctionCallResults.call(
        function_call_name: function_call_name,
        status: "error",
        message: error_message
      )
    end

    def conversation
      Current.conversation
    end
  end
end
