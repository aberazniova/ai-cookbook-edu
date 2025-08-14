module JsonResponseHelpers
  def json_response
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include JsonResponseHelpers, type: :request
end
