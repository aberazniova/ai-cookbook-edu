require "rails_helper"

RSpec.describe Chatbot::BuildPayload::SingleTurn do
  describe "#call" do
    subject(:call) { described_class.call(role: "user", parts: [{ "text" => "Hello" }]) }

    it "returns the correct payload for a single turn" do
      expect(call).to eq({ role: "user", parts: [{ "text" => "Hello" }] })
    end
  end
end
