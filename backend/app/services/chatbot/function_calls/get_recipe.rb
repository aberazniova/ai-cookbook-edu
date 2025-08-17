module Chatbot
  module FunctionCalls
    class GetRecipe
      include Callable

      def initialize(id:, user:)
        @id = id
        @user = user
      end

      def call
        authorise_user!

        {
          "status": "success",
          "data": RecipeDetailSerializer.new(recipe).as_json
        }
      end

      private

      attr_reader :id, :user

      def recipe
        Recipe.find(id)
      end

      def authorise_user!
        Pundit.authorize(user, recipe, :show?)
      end
    end
  end
end
