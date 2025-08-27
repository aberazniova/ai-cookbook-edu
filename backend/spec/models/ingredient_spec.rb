require "rails_helper"

RSpec.describe Ingredient, type: :model do
  describe "validations" do
    context "when amount is present" do
      let(:recipe) { build(:recipe) }

      context "without unit" do
        subject(:ingredient) { build(:ingredient, amount: 2, unit: nil, recipe: recipe) }

        it "is not valid" do
          expect(ingredient).not_to be_valid
        end

        it "adds a unit presence error" do
          ingredient.validate
          expect(ingredient.errors[:unit]).to include("can't be blank")
        end
      end

      context "with unit" do
        subject(:ingredient) { build(:ingredient, amount: 2, unit: "pcs", recipe: recipe) }

        it "is valid" do
          expect(ingredient).to be_valid
        end
      end
    end

    context "when unit is present" do
      let(:recipe) { build(:recipe) }

      context "without amount" do
        subject(:ingredient) { build(:ingredient, unit: "g", amount: nil, recipe: recipe) }

        it "is not valid" do
          expect(ingredient).not_to be_valid
        end

        it "adds an amount presence error" do
          ingredient.validate
          expect(ingredient.errors[:amount]).to include("can't be blank")
        end
      end

      context "with amount" do
        subject(:ingredient) { build(:ingredient, unit: "g", amount: 10, recipe: recipe) }

        it "is valid" do
          expect(ingredient).to be_valid
        end
      end
    end
  end
end
