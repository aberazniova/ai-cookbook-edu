class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :difficulty, :summary, :servings, :created_by, :image_url

  def difficulty
    "medium"
  end

  def summary
    "This is a summary of the recipe."
  end

  def servings
    4
  end

  def cooking_time
    15
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
