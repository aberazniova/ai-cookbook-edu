module Chatbot
  module FunctionCalls
    class CreateRecipe
      include Callable

      def initialize(title:, ingredients:, instructions:)
        @title = title
        @ingredients = ingredients
        @instructions = instructions
      end

      def call
        recipe = Recipes::CreateRecipe.call(title: title, ingredients: ingredients, instructions: instructions)

        {
          "status": "success",
          "message": "Recipe created successfully",
          "data": RecipeDetailSerializer.new(recipe).as_json
        }
      end

      private

      attr_reader :title, :ingredients, :instructions
    end
  end
end
