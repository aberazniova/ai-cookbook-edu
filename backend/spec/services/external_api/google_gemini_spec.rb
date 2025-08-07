require "rails_helper"

RSpec.describe ExternalApi::GoogleGemini do
  describe ".generate_content" do
    subject(:generate_content) { described_class.generate_content(conversation_contents) }

    let(:conversation_contents) { [{ role: "user", parts: [{ text: "Hello" }] }] }
    let(:client_double) { instance_double(ExternalApi::GoogleGemini::Client) }

    before do
      allow(ExternalApi::GoogleGemini::Client).to receive(:new).and_return(client_double)
      allow(client_double).to receive(:generate_content)
    end

    it "calls the client's generate_content method" do
      generate_content
      expect(client_double).to have_received(:generate_content).with(conversation_contents)
    end
  end
end
