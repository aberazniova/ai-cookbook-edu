module Recipes
  class CreateRecipe
    include Callable

    def initialize(user:, params:)
      @user = user
      @params = params
    end

    def call
      authorise_user!

      recipe = user.recipes.create!(recipe_params)
      Recipes::CreateIngredients.call(recipe: recipe, ingredients: ingredients)

      recipe
    end

    private

    attr_reader :user, :params

    def authorise_user!
      Pundit.authorize(user, Recipe, :create?)
    end

    def recipe_params
      params.slice(:title, :instructions, :difficulty, :summary, :cooking_time, :servings)
    end

    def ingredients
      params[:ingredients]
    end
  end
end
