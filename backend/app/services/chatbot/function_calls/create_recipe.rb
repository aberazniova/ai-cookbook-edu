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
        @recipe = Recipes::CreateRecipe.call(user: user, params: params)

        add_artifact

        Chatbot::BuildPayload::FunctionResponsePart.call(
          function_call_name: "create_recipe",
          status: "success",
          message: "Recipe created successfully",
          data: RecipeCompactSerializer.new(recipe).as_json
        )
      end

      private

      attr_reader :params, :user, :recipe

      def add_artifact
        Chatbot::AddArtifact.call(
          kind: "recipe_created",
          data: RecipeCardSerializer.new(recipe).as_json
        )
      end
    end
  end
end
