module Chatbot
  module FunctionCalls
    class CreateRecipe
      include Callable

      def initialize(title:, ingredients:, instructions:, user:, difficulty: nil, summary: nil, cooking_time: nil, servings: nil)
        @user = user
        @params = {
          title: title,
          ingredients: ingredients,
          instructions: instructions,
          difficulty: difficulty,
          summary: summary,
          cooking_time: cooking_time,
          servings: servings
        }
      end

      def call
        recipe = Recipes::CreateRecipe.call(user: user, params: params)

        Chatbot::SaveFunctionCallResults.call(
          function_call_name: "create_recipe",
          message: "Recipe created successfully",
          response_data: RecipeCompactSerializer.new(recipe).as_json,
          artifact_kind: "recipe_created",
          artifact_data: RecipeCardSerializer.new(recipe).as_json
        )
      end

      private

      attr_reader :params, :user
    end
  end
end
