module Chatbot
  module FunctionCalls
    class GetAllRecipes
      include Callable

      def call
        {
          "status": "success",
          "data": recipes_data
        }
      end

      private

      def recipes
        Recipe.all
      end

      def recipes_data
        ActiveModelSerializers::SerializableResource.new(
          recipes,
          each_serializer: RecipeDetailSerializer
        ).as_json
      end
    end
  end
end
