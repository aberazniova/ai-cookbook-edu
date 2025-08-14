require "rails_helper"

RSpec.shared_examples "when unauthorized" do
  context "when access token is not present" do
    let(:headers) { {} }

    it "returns 401" do
      do_request
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "when access token is invalid" do
    let(:headers) { { "Authorization" => "Bearer invalid_token" } }

    it "returns 401" do
      do_request
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
