require "rails_helper"

RSpec.describe Chatbot::AddArtifact do
  describe ".call" do
    subject(:call) { described_class.call(kind: kind, data: data) }

    let(:kind) { "recipe_created" }
    let(:data) { { "title" => "Pasta" } }

    it "adds a new Artifact to Current.artifacts" do
      call

      expect(Current.artifacts.size).to eq(1)
    end

    it "uses the correct attributes for the new Artifact" do
      call

      artifact = Current.artifacts.first

      expect(artifact).to be_a(Artifact)
      expect(artifact.kind).to eq("recipe_created")
      expect(artifact.data).to eq({ "title" => "Pasta" })
    end
  end
end
