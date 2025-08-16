require 'rails_helper'

RSpec.describe RefreshToken, type: :model do
  describe '.find_active_by_raw_token' do
    subject(:find_active_by_raw_token) { described_class.find_active_by_raw_token(raw_token) }

    let(:user) { create(:user) }
    let(:generated_token_result) { RefreshTokens::Generate.call(user: user, ttl: ttl) }
    let(:raw_token) { generated_token_result.raw_token }
    let(:record) { generated_token_result.record }
    let(:ttl) { 1.day }

    it 'returns the active token when valid' do
      expect(find_active_by_raw_token).to eq(record)
    end

    context 'when expired' do
      before do
        record.update!(expires_at: 1.second.ago)
      end

      it 'returns nil when expired' do
        expect(find_active_by_raw_token).to be_nil
      end
    end

    context 'when revoked' do
      before do
        record.revoke!
      end

      it 'returns nil when revoked' do
        expect(find_active_by_raw_token).to be_nil
      end
    end
  end
end
