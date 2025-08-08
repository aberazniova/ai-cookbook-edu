require "rails_helper"

RSpec.describe Chatbot::FunctionCalls::UpdateRecipe do
  subject(:call) do
    described_class.call(
      id: recipe_id,
      title: new_title,
      ingredients: new_ingredients,
      instructions: new_instructions
    )
  end

  let(:recipe) { create(:recipe, title: "Old Title", instructions: "Old instructions") }
  let(:recipe_id) { recipe.id }
  let!(:old_ingredients) { create_list(:ingredient, 2, recipe: recipe) }
  let(:new_title) { "New Title" }
  let(:new_ingredients) { ["Salt", "Pepper"] }
  let(:new_instructions) { "New instructions" }

  it "returns a success status and message" do
    result = call
    expect(result[:status]).to eq("success")
    expect(result[:message]).to eq("Recipe updated successfully")
  end

  it "returns the updated recipe detail data" do
    result = call
    expect(result[:data]).to eq({
      id: recipe.id,
      title: new_title,
      ingredients: new_ingredients,
      instructions: new_instructions
    })
  end

  context "when only some params are provided" do
    subject(:call) { described_class.call(id: recipe.id, title: new_title) }

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
end
