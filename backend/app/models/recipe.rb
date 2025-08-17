# == Schema Information
#
# Table name: recipes
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  title        :string(255)      not null
#  instructions :text(65535)      not null
#  user_id      :integer          not null
#
# Indexes
#
#  index_recipes_on_user_id  (user_id)
#

class Recipe < ApplicationRecord
  belongs_to :user

  has_many :ingredients, dependent: :destroy
end
