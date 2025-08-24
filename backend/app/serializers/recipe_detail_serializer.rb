class RecipeDetailSerializer < ActiveModel::Serializer
  attributes :id, :title, :instructions, :difficulty, :summary, :cooking_time, :servings, :created_by, :created_date, :image_url

  has_many :ingredients, serializer: IngredientSerializer

  def difficulty
    "medium"
  end

  def summary
    "This is a summary of the recipe."
  end

  def cooking_time
    15
  end

  def servings
    4
  end

  def created_by
    object.user.email
  end

  def created_date
    object.created_at.strftime("%B %d, %Y")
  end

  def image_url
    nil
  end
end
