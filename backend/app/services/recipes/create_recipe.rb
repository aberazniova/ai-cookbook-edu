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
      Recipes::CreateIngredients.call(recipe: recipe, ingredients: ingredients)

      recipe
    end

    private

    attr_reader :title, :ingredients, :instructions
  end
end
