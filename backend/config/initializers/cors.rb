# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allowed_origin = ENV["FRONTEND_APP_ORIGIN"]

  if allowed_origin.present?
    allow do
      origins allowed_origin

      resource "*",
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true,
        expose: ["Authorization"]
    end
  else
    Rails.logger.warn "FRONTEND_APP_ORIGIN environment variable is not set. CORS might not be configured correctly."
  end
end
