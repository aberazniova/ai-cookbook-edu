require "spec_helper"
require "rspec/rails"
require "devise/jwt/test_helpers"

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include Devise::Test::IntegrationHelpers, type: :request
end

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }
