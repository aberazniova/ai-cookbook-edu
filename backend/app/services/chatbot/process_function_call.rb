module Chatbot
  class ProcessFunctionCall
    include Callable

    def initialize(function_call_name:, function_call_args:)
      @function_call_name = function_call_name
      @function_call_args = function_call_args
    end

    def call
      case function_call_name
      when "save_recipe"
        puts "Saving recipe with args: #{function_call_args}" # TODO: Implement real function calling
      else
        raise "Function call not supported: #{function_call_name}"
      end
    end

    private

    attr_reader :function_call_name, :function_call_args
  end
end
