class RecipeDetailSerializer < ActiveModel::Serializer
  attributes :id, :title, :instructions, :difficulty, :summary, :cooking_time, :servings, :image_url

  has_many :ingredients, serializer: IngredientSerializer

  def difficulty
    object.difficulty&.to_s
  end

  def image_url
    nil
  end
end
