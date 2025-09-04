module Chatbot
  module BuildPayload
    class FunctionResponsePart
      include Callable

      def initialize(function_call_name:, status:, message: nil, data: nil)
        @function_call_name = function_call_name
        @status = status
        @message = message
        @data = data
      end

      def call
        {
          functionResponse: {
            name: function_call_name,
            response: build_response_payload
          }
        }
      end

      private

      attr_reader :function_call_name, :status, :message, :data

      def build_response_payload
        {
          status: status,
          message: message,
          data: data
        }.compact
      end
    end
  end
end
