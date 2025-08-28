module ConversationTurns
  class CreateFromResponsePayload
    include Callable

    def initialize(response_payload:, conversation:)
      @response_payload = response_payload
      @conversation = conversation
    end

    def call
      ConversationTurns::Create.call(
        message_content: message_content,
        role: role,
        payload: sanitized_payload,
        conversation: conversation
      )
    end

    private

    attr_reader :response_payload, :conversation

    def message_content
      text_parts.join("\n\n").presence
    end

    def role
      :model
    end

    def sanitized_payload
      # Remove thoughtSignature as we don't need to pass it to Gemini with history
      sanitized_parts = parts.map { |part| part.except("thoughtSignature") }

      response_payload.merge("parts" => sanitized_parts)
    end

    def parts
      response_payload["parts"] || []
    end

    def text_parts
      parts.filter_map { |p| p["text"] }
    end
  end
end
