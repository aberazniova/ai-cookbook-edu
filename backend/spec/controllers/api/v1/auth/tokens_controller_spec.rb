require "rails_helper"

RSpec.describe "Tokens Refresh", type: :request do
  describe "POST /api/v1/auth/refresh" do
    subject(:do_request) { post "/api/v1/auth/refresh", as: :json, headers: headers }

    let(:password) { "Password!" }
    let(:user) { create(:user, password: password, password_confirmation: password) }

    context "when refresh token is missing" do
      let(:headers) { {} }

      it "returns unauthorized" do
        do_request
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when refresh token is present" do
      subject(:refresh_response) { response }

      before do
        # Sign in first to receive the HttpOnly encrypted refresh cookie
        post "/api/v1/auth/sign_in", params: { user: { email: user.email, password: password } }, as: :json

        set_cookie = response.headers["Set-Cookie"]
        refresh_cookie = set_cookie.to_s.split("\n").find { |c| c.start_with?("refresh_token=") }
        cookie_header = refresh_cookie.split(";").first

        post "/api/v1/auth/refresh", headers: { "Cookie" => cookie_header }, as: :json
      end

      it "responds with ok" do
        expect(refresh_response).to have_http_status(:ok)
      end

      it "sets the Authorization header" do
        expect(response.headers["Authorization"]).to be_present
      end

      it "returns the user id in the response body" do
        expect(json_response["id"]).to eq(user.id)
      end
    end
  end
end
