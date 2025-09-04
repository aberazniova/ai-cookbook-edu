require "rails_helper"

RSpec.describe Chatbot::FunctionCalls::UpdateRecipe do
  subject(:call) do
    described_class.call(
      id: recipe_id,
      title: new_title,
      ingredients: new_ingredients,
      instructions: new_instructions,
      difficulty: :easy,
      summary: "Summary",
      cooking_time: 10,
      servings: 4,
      user: user
    )
  end

  let(:user) { recipe.user }
  let(:recipe) { create(:recipe, title: "Old Title", instructions: "Old instructions") }
  let(:recipe_id) { recipe.id }

  let!(:old_ingredients) { create_list(:ingredient, 2, recipe: recipe) }
  let(:new_title) { "New Title" }
  let(:new_ingredients) { [{ name: "Salt", amount: 1, unit: "tsp" }] }
  let(:new_instructions) { "New instructions" }

  it "adds an artifact for the updated recipe" do
    expect(Chatbot::AddArtifact).to receive(:call).with(
      kind: "recipe_updated",
      data: hash_including(title: new_title)
    )
    call
  end

  it "returns function response payload with updated recipe details" do
    expect(call).to eq({
      functionResponse: {
        name: "update_recipe",
        response: {
          status: "success",
          message: "Recipe updated successfully",
          data: RecipeCompactSerializer.new(recipe.reload).as_json
        }
      }
    })
  end

  context "when only some params are provided" do
    subject(:call) { described_class.call(id: recipe.id, title: new_title, user: user) }

    it "updates only the provided fields" do
      call
      recipe.reload
      expect(recipe.title).to eq(new_title)
    end

    it "does not change the fields that are not provided" do
      call
      recipe.reload
      expect(recipe.instructions).to eq("Old instructions")
    end

    it "does not change the ingredients if not provided" do
      call
      recipe.reload
      expect(recipe.ingredients.pluck(:name)).to eq(old_ingredients.pluck(:name))
    end
  end

  context "when the recipe is not found" do
    let(:recipe_id) { -1 }

    it "raises a RecordNotFound error" do
      expect { call }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when user is not authorized' do
    let(:user) { create(:user) }

    it 'raises Pundit::NotAuthorizedError' do
      expect { call }.to raise_error(Pundit::NotAuthorizedError)
    end
  end
end
