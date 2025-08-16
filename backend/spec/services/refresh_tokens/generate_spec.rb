require 'rails_helper'

RSpec.describe RefreshTokens::Generate do
  describe '.call' do
    subject(:call) { described_class.call(user: user, ttl: 1.day) }

    let(:user) { create(:user) }

    it 'creates a RefreshToken record' do
      expect { call }.to change(RefreshToken, :count).by(1)
    end

    it 'returns the raw token as a string' do
      expect(call.raw_token).to be_a(String)
    end

    it 'associates the token with the user' do
      expect(call.record.user).to eq(user)
    end

    it 'sets an expiry in the future' do
      expect(call.record.expires_at).to be > Time.current
    end

    it 'token record is findable via the raw token' do
      result = call
      expect(RefreshToken.find_active_by_raw_token(result.raw_token)).to eq(result.record)
    end
  end
end
