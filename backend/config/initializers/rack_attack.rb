class Rack::Attack
  throttling_enabled = !!ENV["ENABLE_THROTTLING"] || Rails.env.production?

  if throttling_enabled
    throttle("signups/ip", limit: 10, period: 30.minutes) do |req|
      req.ip if req.path == "/api/v1/auth/sign_up" && req.post?
    end

    throttle("signins/ip", limit: 10, period: 10.minutes) do |req|
      req.ip if req.path == "/api/v1/auth/sign_in" && req.post?
    end

    throttle("refresh_tokens/ip", limit: 60, period: 30.minutes) do |req|
      req.ip if req.path == "/api/v1/auth/refresh" && req.post?
    end

    throttle("signins/email", limit: 10, period: 10.minutes) do |req|
      if req.path == "/api/v1/auth/sign_in" && req.post?
        begin
          body = req.body.read
          req.body.rewind
          parsed = JSON.parse(body)
          email = parsed.dig("user", "email") || parsed["email"]
          email&.downcase
        rescue StandardError
          nil
        end
      end
    end
  end

  self.throttled_responder = lambda do |env|
    [
      429,
      { "Content-Type" => "application/json" },
      [{ error: "Throttle limit reached. Try again later." }.to_json]
    ]
  end
end
