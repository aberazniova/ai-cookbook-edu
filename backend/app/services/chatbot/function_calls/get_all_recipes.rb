module Chatbot
  module FunctionCalls
    class GetAllRecipes < Base
      def initialize(user:)
        super
      end

      def call
        success_payload(recipes_data)
      end

      private

      def recipes_data
        ActiveModelSerializers::SerializableResource.new(
          recipes,
          each_serializer: RecipeDetailSerializer
        ).as_json
      end

      def recipes
        Pundit.policy_scope!(user, Recipe)
      end
    end
  end
end
