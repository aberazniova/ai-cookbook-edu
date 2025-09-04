module Chatbot
  class AddArtifact
    include Callable

    def initialize(kind:, data:)
      @kind = kind
      @data = data
    end

    def call
      Current.artifacts = [] if Current.artifacts.nil?

      Current.artifacts << Artifact.new(
        kind: kind,
        data: data
      )
    end

    private

    attr_reader :kind, :data
  end
end
