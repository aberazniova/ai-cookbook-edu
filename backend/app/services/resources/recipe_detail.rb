class Resources::RecipeDetail
  include Callable

  def initialize(recipe)
    @recipe = recipe
  end

  def call
    {
      id: recipe.id,
      title: recipe.title,
      instructions: recipe.instructions,
      ingredients: ingredients,
    }
  end

  private

  attr_reader :recipe

  def ingredients
    recipe.ingredients.map { |ingredient| ingredient_data(ingredient) }
  end

  def ingredient_data(ingredient)
    {
      name: ingredient.name,
    }
  end
end
