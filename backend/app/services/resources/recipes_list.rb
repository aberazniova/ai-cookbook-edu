class Resources::RecipesList
  include Callable

  def initialize(recipes)
    @recipes = recipes
  end

  def call
    {
      recipes: recipes.map { |recipe| recipe_data(recipe) }
    }
  end

  private

  attr_reader :recipes

  def recipe_data(recipe)
    {
      id: recipe.id,
      title: recipe.title
    }
  end
end
