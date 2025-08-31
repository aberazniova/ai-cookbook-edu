module Chatbot
  module FunctionCalls
    class GetAllRecipes
      include Callable

      def initialize(user:)
        @user = user
      end

      def call
        Chatbot::SaveFunctionCallResults.call(
          function_call_name: "get_all_recipes",
          response_data: recipes_data,
        )
      end

      private

      attr_reader :user

      def recipes_data
        ActiveModelSerializers::SerializableResource.new(
          recipes,
          each_serializer: RecipeDetailSerializer
        ).as_json
      end

      def recipes
        Pundit.policy_scope!(user, Recipe)
      end
    end
  end
end
