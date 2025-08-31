class MessageSerializer < ActiveModel::Serializer
  attributes :text_content, :role, :id

  def role
    object.role.to_s
  end
end
