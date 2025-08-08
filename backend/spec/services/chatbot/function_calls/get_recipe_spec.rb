require "rails_helper"

RSpec.describe Chatbot::FunctionCalls::GetRecipe do
  describe "#call" do
    subject(:call) { described_class.call(id: recipe_id) }

    context "when the recipe exists" do
      let(:recipe) { create(:recipe, :with_ingredients) }
      let(:recipe_id) { recipe.id }
      let(:recipe_detail) do
        {
          id: recipe.id,
          title: recipe.title,
          instructions: recipe.instructions,
          ingredients: recipe.ingredients.map { |ingredient| { name: ingredient.name } }
        }
      end

      it "returns a success status and the recipe data" do
        expect(call).to eq(
          {
            "status": "success",
            "data": recipe_detail
          }
        )
      end
    end

    context "when the recipe is not found" do
      let(:recipe_id) { -1 }

      it "raises a RecordNotFound error" do
        expect { call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
