module Recipes
  class CreateRecipe
    include Callable

    def initialize(title:, ingredients:, instructions:, user:)
      @title = title
      @ingredients = ingredients
      @instructions = instructions
      @user = user
    end

    def call
      authorise_user!

      recipe = Recipe.create!(title: title, instructions: instructions, user: user)
      Recipes::CreateIngredients.call(recipe: recipe, ingredients: ingredients)

      recipe
    end

    private

    attr_reader :title, :ingredients, :instructions, :user

    def authorise_user!
      Pundit.authorize(user, Recipe, :create?)
    end
  end
end
