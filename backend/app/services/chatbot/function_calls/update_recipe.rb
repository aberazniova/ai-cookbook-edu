module Chatbot
  module FunctionCalls
    class UpdateRecipe
      include Callable

      def initialize(id:, user:, title: nil, ingredients: nil, instructions: nil)
        @id = id
        @user = user
        @title = title
        @ingredients = ingredients
        @instructions = instructions
      end

      def call
        updated_recipe = Recipes::UpdateRecipe.call(recipe: recipe, params: update_params, user: user)

        {
          "status": "success",
          "message": "Recipe updated successfully",
          "data": RecipeDetailSerializer.new(updated_recipe).as_json
        }
      end

      private

      attr_reader :id, :title, :ingredients, :instructions, :user

      def recipe
        Recipe.find(id)
      end

      def update_params
        {
          title: title,
          ingredients: ingredients,
          instructions: instructions
        }.compact
      end
    end
  end
end
