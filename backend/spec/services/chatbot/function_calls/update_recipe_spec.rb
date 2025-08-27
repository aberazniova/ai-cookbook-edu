require "rails_helper"

RSpec.describe Chatbot::FunctionCalls::UpdateRecipe do
  let(:user) { create(:user) }
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

  let(:recipe) { create(:recipe, title: "Old Title", instructions: "Old instructions", user: user) }
  let(:recipe_id) { recipe.id }
  let!(:old_ingredients) { create_list(:ingredient, 2, recipe: recipe) }
  let(:new_title) { "New Title" }
  let(:new_ingredients) { [{ name: "Salt", amount: 1, unit: "tsp" }] }
  let(:new_instructions) { "New instructions" }

  it "returns a success status and message" do
    result = call
    expect(result[:status]).to eq("success")
    expect(result[:message]).to eq("Recipe updated successfully")
  end

  it "returns the updated recipe detail data" do
    result = call
    recipe.reload
    expect(result[:data]).to eq({
      id: recipe.id,
      title: recipe.title,
      instructions: recipe.instructions,
      ingredients: recipe.ingredients.map { |ingredient| { name: ingredient.name, amount: ingredient.amount.to_s, unit: ingredient.unit } },
      difficulty: recipe.difficulty,
      summary: recipe.summary,
      cooking_time: recipe.cooking_time,
      servings: recipe.servings,
      image_url: nil
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
end
