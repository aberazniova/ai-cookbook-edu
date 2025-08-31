require "rails_helper"

RSpec.describe Chatbot::FunctionCalls::GetRecipe do
  describe "#call" do
    subject(:call) { described_class.call(id: recipe_id, user: user) }

    let(:user) { create(:user) }
    let(:recipe) { create(:recipe, user: user) }
    let(:recipe_id) { recipe.id }

    context "when the recipe exists" do
      let(:recipe) { create(:recipe, :with_ingredients, user: user) }
      let(:recipe_id) { recipe.id }
      let(:recipe_detail) { RecipeDetailSerializer.new(recipe).as_json }

      it "saves the function call results with found recipe details" do
        expect(Chatbot::SaveFunctionCallResults).to receive(:call).with(
          function_call_name: "get_recipe",
          response_data: recipe_detail
        )
        call
      end
    end

    context "when the recipe is not found" do
      let(:recipe_id) { -1 }

      it "raises a RecordNotFound error" do
        expect { call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when the recipe belongs to another user" do
      let(:other_user) { create(:user) }
      let(:recipe) { create(:recipe, :with_ingredients, user: other_user) }

      it "raises a NotAuthorizedError" do
        expect { call }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
