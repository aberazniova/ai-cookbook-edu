module Recipes
  class CreateRecipe
    include Callable

    def initialize(title:, ingredients:, instructions:)
      @title = title
      @ingredients = ingredients
      @instructions = instructions
    end

    def call
      recipe = Recipe.create!(title: title, instructions: instructions)

      ingredients.each { |ingredient| create_ingredient(recipe, ingredient) }

      recipe
    end

    private

    attr_reader :title, :ingredients, :instructions

    def create_ingredient(recipe, name)
      Ingredient.create!(recipe: recipe, name: name)
    end
  end
end
