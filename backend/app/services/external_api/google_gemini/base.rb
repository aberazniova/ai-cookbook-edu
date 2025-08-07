module ExternalApi
  module GoogleGemini
    class Base < ApiAdapter::Base
      def initialize
        super(
          base_url: api_url,
          options: {
            headers: headers
          }
        )
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
    end
  end
end
