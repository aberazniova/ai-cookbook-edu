class RecipeCardSerializer < ActiveModel::Serializer
  attributes :id, :title, :difficulty, :summary, :servings, :cooking_time, :created_by, :created_date, :image_url

  def difficulty
    object.difficulty&.to_s
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
