module Chatbot
  class GenerateResponseMessage
    include Callable

    Result = Struct.new(:success, :response_message, :error)

    def initialize(message:)
      @message = message
    end

    def call
      Result.new(true, generate_response, nil)
    rescue StandardError => e
      Rails.logger.error("Error generating chatbot response: #{e.message}")
      Result.new(false, nil, e.message)
    end

    private

    attr_reader :message

    def gemini_client
      @_gemini_client ||= ExternalApi::GoogleGemini::Client.new
    end

    def response_payload
      @_response_payload = gemini_client.generate_content(message)
    end

    def function_call
      return @_function_call if defined?(@_function_call)

      @_function_call = response_content.dig("functionCall")
    end

    def response_content
      @_response_content ||= response_payload.dig("candidates", 0, "content", "parts", 0)
    end

    def generate_response
      if function_call.present?
        process_function_call
      else
        response_content.dig("text")
      end
    end

    def process_function_call
      function_call_name = function_call.dig("name")

      case function_call_name
      when "save_recipe"
        puts "Saving recipe with args: #{function_call.dig("args")}" # TODO: Implement real function calling
      else
        raise "Function call not supported: #{function_call_name}"
      end
    end
  end
end
