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
        authorise_user!

        @updated_recipe = Recipes::UpdateRecipe.call(recipe: recipe, params: params, user: user)
        add_artifact

        Chatbot::BuildPayload::FunctionResponsePart.call(
          function_call_name: "update_recipe",
          status: "success",
          message: "Recipe updated successfully",
          data: RecipeCompactSerializer.new(updated_recipe).as_json
        )
      end

      private

      attr_reader :id, :params, :user, :updated_recipe

      def recipe
        @recipe ||= Recipe.find(id)
      end

      def authorise_user!
        Pundit.authorize(user, recipe, :update?)
      end

      def add_artifact
        Chatbot::AddArtifact.call(
          kind: "recipe_updated",
          data: RecipeDetailSerializer.new(updated_recipe).as_json
        )
      end
    end
  end
end
