module Recipes
  class CreateIngredients
    include Callable

    def initialize(recipe:, ingredients:)
      @recipe = recipe
      @ingredients = ingredients
    end

    def call
      ingredients.each { |ingredient| create_ingredient(ingredient) }
    end

    private

    attr_reader :recipe, :ingredients

    def create_ingredient(ingredient)
      recipe.ingredients.create!(params(ingredient))
    end

    def params(ingredient)
      ingredient.with_indifferent_access.slice(:name, :amount, :unit)
    end
  end
end
