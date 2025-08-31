# frozen_string_literal: true

class Artifact
  attr_accessor :kind, :data

  def initialize(kind:, data:)
    @kind = kind
    @data = data
  end
end
