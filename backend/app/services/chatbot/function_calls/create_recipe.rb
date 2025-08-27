module Chatbot
  module FunctionCalls
    class CreateRecipe < Base
      def initialize(title:, ingredients:, instructions:, user:, difficulty: nil, summary: nil, cooking_time: nil, servings: nil)
        super(user: user)

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

        success_payload(
          RecipeDetailSerializer.new(recipe).as_json,
          message: "Recipe created successfully"
        )
      end

      private

      attr_reader :params
    end
  end
end
