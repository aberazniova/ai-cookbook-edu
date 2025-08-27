
require "rails_helper"

RSpec.describe Recipes::UpdateRecipe do
  let(:user) { create(:user) }
  subject(:call) { described_class.call(recipe: recipe, params: params, user: user) }

  let(:recipe) { create(:recipe, title: "Old Title", instructions: "Old instructions", user: user) }
  let(:new_title) { "New Title" }
  let(:new_instructions) { "New instructions" }
  let(:params) { { title: new_title, instructions: new_instructions } }
  let!(:old_ingredients) { create_list(:ingredient, 2, recipe: recipe) }

  it "updates the recipe with the provided params" do
    call
    recipe.reload
    expect(recipe.title).to eq(new_title)
    expect(recipe.instructions).to eq(new_instructions)
  end

  context "when ingredients are provided" do
    let(:new_ingredients) { [{ name: "Salt", amount: 1, unit: "tsp" }, { name: "Pepper", amount: 2, unit: "tbsp" }] }
    let(:params) { { ingredients: new_ingredients } }

    it "replaces the recipe's ingredients with a new list" do
      call
      recipe.reload
      expect(recipe.ingredients.pluck(:name)).to match_array(["Salt", "Pepper"])
    end
  end

  context "when ingredients are not provided" do
    let(:params) { { title: "New title" } }

    it "does not update the recipe's ingredients" do
      call
      recipe.reload
      expect(recipe.ingredients.pluck(:name)).to match_array(old_ingredients.pluck(:name))
    end
  end

  context "when the recipe belongs to another user" do
    let(:other_user) { create(:user) }
    let(:recipe) { create(:recipe, user: other_user) }

    it "raises a NotAuthorizedError when trying to update" do
      expect { call }.to raise_error(Pundit::NotAuthorizedError)
    end
  end
end
