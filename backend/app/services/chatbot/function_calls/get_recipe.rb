module Chatbot
  module FunctionCalls
    class GetRecipe
      include Callable

      def initialize(id:)
        @id = id
      end

      def call
        {
          "status": "success",
          "data": Resources::RecipeDetail.call(recipe)
        }
      rescue StandardError => e
        {
          "status": "error",
          "message": e.message
        }
      end

      private

      attr_reader :id

      def recipe
        Recipe.find(id)
      end
    end
  end
end
