module Chatbot
  class ProcessFunctionCalls
    include Callable

    def initialize(function_calls:)
      @function_calls = function_calls
    end

    def call
      @function_response_parts = function_calls.map do |function_call|
        Chatbot::ProcessFunctionCall.call(
          function_call_name: function_call.dig("name"),
          function_call_args: function_call.dig("args")
        )
      end

      create_conversation_turn

      Chatbot::GenerateResponse.call
    end

    private

    attr_reader :function_calls, :function_response_parts

    def create_conversation_turn
      ConversationTurns::CreateFromRawParts.call(
        parts: function_response_parts,
        role: :user,
        conversation: conversation
      )
    end

    def conversation
      Current.conversation
    end
  end
end
