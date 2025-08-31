module Chatbot
  class SaveFunctionCallResults
    include Callable

    def initialize(function_call_name:, status: "success", response_data: nil, message: nil, artifact_kind: nil, artifact_data: nil)
      @message = message
      @response_data = response_data
      @artifact_kind = artifact_kind
      @artifact_data = artifact_data
      @function_call_name = function_call_name
      @status = status
    end

    def call
      conversation_turn = create_conversation_turn

      if create_artifact?
        Current.artifacts << Artifact.new(
          kind: artifact_kind,
          data: artifact_data
        )
      end
    end

    private

    attr_reader :function_call_name, :message, :response_data, :artifact_kind, :artifact_data, :status

    def create_conversation_turn
      ConversationTurns::CreateFromFunctionResponse.call(
        function_call_name: function_call_name,
        function_response_part: {
          name: function_call_name,
          response: build_response_payload
        },
        conversation: conversation,
      )
    end

    def build_response_payload
      {
        status: status,
        message: message,
        data: response_data
      }.compact
    end

    def conversation
      @_conversation ||= Current.conversation
    end

    def create_artifact?
      artifact_kind.present? && artifact_data.present?
    end
  end
end
