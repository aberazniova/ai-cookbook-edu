module ExternalApi
  module ApiAdapter
    class Error < StandardError
      def initialize(base_message, response)
        super(get_extended_message(base_message, response))
      end

      private

      def get_extended_message(base_message, response)
        error_body = JSON.parse(response.dig(:body)) rescue {}
        message_from_response = error_body.dig("error", "message")

        return base_message if message_from_response.blank?

        message_from_response
      end
    end
  end
end
