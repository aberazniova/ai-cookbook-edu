module ExternalApi
  module ApiAdapter
    # Base class for API adapters
    # Provides common functionality for making API requests
    # and error handling
    class Base
      def initialize(base_url:, options: {})
        @connection = Faraday.new(base_url, **options) do |faraday|
          faraday.request :json
          faraday.response :json
          faraday.response :raise_error
        end
      end

      private

      attr_reader :connection

      def post(url, body = {})
        request_handler(:post, url, body)
      end

      def request_handler(method, *)
        response = connection.send(method, *)
        response.body
      rescue Faraday::Error => error
        raise ExternalApi::ApiAdapter::Error.new(error.message, error.response)
      end
    end
  end
end
