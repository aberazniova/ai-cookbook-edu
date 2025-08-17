module Chatbot
  module FunctionCalls
    class CreateRecipe
      include Callable

      def initialize(title:, ingredients:, instructions:, user:)
        @title = title
        @ingredients = ingredients
        @instructions = instructions
        @user = user
      end

      def call
        recipe = Recipes::CreateRecipe.call(
          title: title,
          ingredients: ingredients,
          instructions: instructions,
          user: user
        )

        {
          "status": "success",
          "message": "Recipe created successfully",
          "data": RecipeDetailSerializer.new(recipe).as_json
        }
      end

      private

      attr_reader :title, :ingredients, :instructions, :user
    end
  end
end
