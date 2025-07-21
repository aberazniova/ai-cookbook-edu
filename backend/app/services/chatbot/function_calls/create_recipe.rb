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
          "message": "Recipe saved successfully",
          "data": Resources::RecipeDetail.call(recipe),
        }
      rescue StandardError => e
        {
          "status": "error",
          "message": e.message
        }
      end

      private

      attr_reader :title, :ingredients, :instructions
    end
  end
end
