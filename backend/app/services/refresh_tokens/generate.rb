# frozen_string_literal: true

module RefreshTokens
  class Generate
    include Callable

    Result = Struct.new(:raw_token, :record)

    def initialize(user:, ttl: 30.days)
      @user = user
      @ttl = ttl
    end

    def call
      record = user.refresh_tokens.create!(token_digest: digest, expires_at: ttl.from_now)

      Result.new(raw_token, record)
    end

    private

    attr_reader :user, :ttl

    def raw_token
      @raw_token ||= SecureRandom.hex(32)
    end

    def digest
      @digest ||= RefreshToken.digest_for(raw_token)
    end
  end
end
