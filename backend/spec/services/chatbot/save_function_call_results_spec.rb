require "rails_helper"

RSpec.describe Chatbot::SaveFunctionCallResults do
  describe ".call" do
    subject(:call) { described_class.call(**args) }

    let(:conversation) { create(:conversation) }
    let(:args) do
      {
        function_call_name: "create_recipe"
      }.merge(extra_args)
    end

    let(:extra_args) { {} }

    before do
      allow(Current).to receive(:conversation).and_return(conversation)
      allow(ConversationTurns::CreateFromFunctionResponse).to receive(:call).and_return(build(:conversation_turn))
    end

    it "calls ConversationTurns::CreateFromFunctionResponse with a response payload containing status" do
      call

      expect(ConversationTurns::CreateFromFunctionResponse).to have_received(:call) do |passed_args|
        expect(passed_args[:function_call_name]).to eq("create_recipe")
        expect(passed_args[:conversation]).to eq(conversation)
        expect(passed_args[:function_response_part][:name]).to eq("create_recipe")
        expect(passed_args[:function_response_part][:response]).to eq({ status: "success" })
      end
    end

    context "when message and response_data are present" do
      let(:extra_args) { { message: "Done", response_data: { "id" => 1 }, status: "success" } }

      it "includes message and data in the response payload" do
        call

        expect(ConversationTurns::CreateFromFunctionResponse).to have_received(:call) do |passed_args|
          expect(passed_args[:function_response_part][:response]).to eq({ status: "success", message: "Done", data: { "id" => 1 } })
        end
      end
    end

    context "when artifact_kind and artifact_data are provided" do
      let(:extra_args) { { artifact_kind: "recipe_created", artifact_data: { "title" => "Pasta" } } }

      it "adds a new Artifact to Current.artifacts" do
        call

        artifacts = Current.artifacts

        expect(artifacts.size).to eq(1)
        artifact = artifacts.first
        expect(artifact).to be_a(Artifact)
        expect(artifact.kind).to eq("recipe_created")
        expect(artifact.data).to eq({ "title" => "Pasta" })
      end
    end
  end
end
