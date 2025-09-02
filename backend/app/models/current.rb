# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :conversation
  attribute :artifacts
  attribute :viewed_recipe_id
end
