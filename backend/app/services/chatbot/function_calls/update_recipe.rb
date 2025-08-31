module Chatbot
  module FunctionCalls
    class UpdateRecipe
      include Callable

      def initialize(id:, user:, title: nil, ingredients: nil, instructions: nil, difficulty: nil, summary: nil, cooking_time: nil, servings: nil)
        @user = user
        @id = id

        @params =  {
          title: title,
          ingredients: ingredients,
          instructions: instructions,
          difficulty: difficulty,
          summary: summary,
          cooking_time: cooking_time,
          servings: servings
        }.compact
      end

      def call
        updated_recipe = Recipes::UpdateRecipe.call(recipe: recipe, params: params, user: user)

        Chatbot::SaveFunctionCallResults.call(
          function_call_name: "update_recipe",
          message: "Recipe updated successfully",
          response_data: RecipeCompactSerializer.new(updated_recipe).as_json,
          artifact_kind: "recipe_updated",
          artifact_data: RecipeDetailSerializer.new(updated_recipe).as_json
        )
      end

      private

      attr_reader :id, :params, :user

      def recipe
        Recipe.find(id)
      end
    end
  end
end
