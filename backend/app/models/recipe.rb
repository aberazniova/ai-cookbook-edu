# == Schema Information
#
# Table name: recipes
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  title        :string(255)      not null
#  instructions :text(65535)      not null
#

class Recipe < ApplicationRecord
  has_many :ingredients, dependent: :destroy
end
