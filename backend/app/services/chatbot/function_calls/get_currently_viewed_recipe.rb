module Chatbot
  module FunctionCalls
    class GetCurrentlyViewedRecipe
      include Callable

      def initialize(user:)
        @user = user
      end

      def call
        unless viewed_recipe_id.present?
          return no_recipe_viewed_response
        end

        authorise_user!

        Chatbot::BuildPayload::FunctionResponsePart.call(
          function_call_name: "get_currently_viewed_recipe",
          status: "success",
          data: RecipeDetailSerializer.new(recipe).as_json
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

      def no_recipe_viewed_response
        Chatbot::BuildPayload::FunctionResponsePart.call(
          function_call_name: "get_currently_viewed_recipe",
          status: "success",
          message: "No recipe is currently viewed"
        )
      end
    end
  end
end
