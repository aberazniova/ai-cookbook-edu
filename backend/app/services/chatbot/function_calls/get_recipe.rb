module Chatbot
  module FunctionCalls
    class GetRecipe
      include Callable

      def initialize(id:, user:)
        @user = user
        @id = id
      end

      def call
        authorise_user!

        Chatbot::SaveFunctionCallResults.call(
          function_call_name: "get_recipe",
          response_data: RecipeDetailSerializer.new(recipe).as_json
        )
      end

      private

      attr_reader :id, :user

      def recipe
        @recipe ||= Recipe.find(id)
      end

      def authorise_user!
        Pundit.authorize(user, recipe, :show?)
      end
    end
  end
end
