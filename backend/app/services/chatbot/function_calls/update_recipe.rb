module Chatbot
  module FunctionCalls
    class UpdateRecipe < Base
      def initialize(id:, user:, title: nil, ingredients: nil, instructions: nil, difficulty: nil, summary: nil, cooking_time: nil, servings: nil)
        super(user: user)

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

        success_payload(
          RecipeDetailSerializer.new(updated_recipe).as_json,
          message: "Recipe updated successfully"
        )
      end

      private

      attr_reader :id, :params

      def recipe
        Recipe.find(id)
      end
    end
  end
end
