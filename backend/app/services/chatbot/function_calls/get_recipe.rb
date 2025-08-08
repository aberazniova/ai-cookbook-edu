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
          "data": RecipeDetailSerializer.new(recipe).as_json
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
