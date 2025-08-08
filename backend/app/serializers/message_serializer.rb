class MessageSerializer < ActiveModel::Serializer
  attributes :text_content, :role

  def role
    object.role.to_s
  end
end
