require 'rails_helper'

RSpec.describe ExternalApi::GoogleGemini::Client do
  let(:client) { described_class.new }

  describe "#generate_content" do
    subject(:generate_content) { client.generate_content(conversation_contents) }

    let(:conversation_contents) { [{ role: "user", parts: [{ text: "Hello" }] }] }
    let(:faraday_connection) { instance_double(Faraday::Connection) }
    let(:faraday_response) { instance_double(Faraday::Response, body: { "candidates" => [] }.to_json) }
    let(:gemini_config) { { "example_gemini_config" => [] } }

    before do
      allow(Faraday).to receive(:new).and_return(faraday_connection)
      allow(faraday_connection).to receive(:post).and_return(faraday_response)
      allow(YAML).to receive(:load_file).and_return(gemini_config)
    end

    it "makes a post request with the correct payload" do
      expected_payload = {
        **gemini_config,
        contents: conversation_contents,
        generationConfig: {
          temperature: 1.2
        }
      }

      generate_content

      expect(faraday_connection).to have_received(:post)
        .with("", expected_payload)
    end

    context "when Faraday raises an error" do
      let(:error_message) { "Server responded with status 400" }
      let(:response) { { status: 400, body: error_body } }
      let(:faraday_error) { Faraday::Error.new(error_message, response) }
      let(:detailed_error_message) { "Specific error detail" }
      let(:error_body) do
        JSON.generate({
          "error" => {
            "message" => detailed_error_message
          }
        })
      end

      before do
        allow(faraday_connection).to receive(:post).and_raise(faraday_error)
      end

      it "raises an ExternalApi::ApiAdapter::Error with an extended message" do
        expected_error_message = error_message + "\n" + detailed_error_message
        expect { generate_content }.to raise_error(ExternalApi::ApiAdapter::Error, expected_error_message)
      end
    end
  end
end
