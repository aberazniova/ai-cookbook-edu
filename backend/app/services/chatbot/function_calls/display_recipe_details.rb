module Chatbot
  module FunctionCalls
    class DisplayRecipeDetails
      include Callable

      def initialize(id:, user:)
        @user = user
        @id = id
      end

      def call
        authorise_user!

        Chatbot::SaveFunctionCallResults.call(
          function_call_name: "display_recipe_details",
          artifact_kind: "recipe_details",
          artifact_data: RecipeCardSerializer.new(recipe).as_json
        )
      end

      private

      attr_reader :id, :user

      def recipe
        Recipe.find(id)
      end

      def authorise_user!
        Pundit.authorize(user, recipe, :show?)
      end
    end
  end
end
