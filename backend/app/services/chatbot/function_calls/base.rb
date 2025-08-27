module Chatbot
  module FunctionCalls
    class Base
      include Callable

      def initialize(user:)
        @user = user
      end

      private

      attr_reader :user

      def success_payload(data, message: nil)
        {
          status: "success",
          message: message,
          data: data
        }.compact
      end
    end
  end
end
