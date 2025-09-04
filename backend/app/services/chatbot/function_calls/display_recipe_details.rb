module Chatbot
  module FunctionCalls
    class DisplayRecipeDetails
      include Callable

      def initialize(id:, user:)
        @user = user
        @id = id
      end

      def call
        authorise_user!
        add_artifact

        Chatbot::BuildPayload::FunctionResponsePart.call(
          function_call_name: "display_recipe_details",
          status: "success",
          data: RecipeCardSerializer.new(recipe).as_json
        )
      end

      private

      attr_reader :id, :user

      def recipe
        @recipe ||= Recipe.find(id)
      end

      def authorise_user!
        Pundit.authorize(user, recipe, :show?)
      end

      def add_artifact
        Chatbot::AddArtifact.call(
          kind: "recipe_details",
          data: RecipeCardSerializer.new(recipe).as_json
        )
      end
    end
  end
end
