module Chatbot
  module FunctionCalls
    class GetCurrentlyViewedRecipe
      include Callable

      def initialize(user:)
        @user = user
      end

      def call
        unless viewed_recipe_id.present?
          Chatbot::SaveFunctionCallResults.call(
            function_call_name: "get_currently_viewed_recipe",
            message: "No recipe is currently viewed"
          )
          return
        end

        authorise_user!

        Chatbot::SaveFunctionCallResults.call(
          function_call_name: "get_currently_viewed_recipe",
          response_data: RecipeDetailSerializer.new(recipe).as_json
        )
      end

      private

      attr_reader :user

      def viewed_recipe_id
        Current.viewed_recipe_id
      end

      def recipe
        Recipe.find(viewed_recipe_id)
      end

      def authorise_user!
        Pundit.authorize(user, recipe, :show?)
      end
    end
  end
end
