class MessageSerializer < ActiveModel::Serializer
  attributes :text_content, :role, :id, :recipe

  def role
    object.role.to_s
  end

  def recipe
    nil
  end
end
