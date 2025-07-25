module ExternalApi
  module GoogleGemini
    class Base
      def initialize
        @connection = Faraday.new(
          url: api_url,
          headers: headers,
        ) do |faraday|
          faraday.response :raise_error
        end
      end

      private

      attr_reader :connection

      def api_url
        ENV.fetch("GOOGLE_GEMINI_API_URL")
      end

      def api_key
        ENV.fetch("GOOGLE_GEMINI_API_KEY")
      end

      def headers
        {
          'x-goog-api-key': api_key
        }
      end

      def post(url, body = {})
        response = connection.post(url, body.to_json, "Content-Type" => "application/json")
        JSON.parse(response.body)
      end
    end
  end
end
