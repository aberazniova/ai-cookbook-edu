module Chatbot
  module FunctionCalls
    class GetRecipe < Base
      def initialize(id:, user:)
        super(user: user)
        @id = id
      end

      def call
        authorise_user!

        success_payload(RecipeDetailSerializer.new(recipe).as_json)
      end

      private

      attr_reader :id

      def recipe
        Recipe.find(id)
      end

      def authorise_user!
        Pundit.authorize(user, recipe, :show?)
      end
    end
  end
end
