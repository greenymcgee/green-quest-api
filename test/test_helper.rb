ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require_relative "./support/mock_json_fixtures"
require "rails/test_help"
require "devise/jwt/test_helpers"
require "minitest/autorun"
require "json_matchers/minitest/assertions"
require "webmock/minitest"
# Require all of the test helpers
Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

JsonMatchers.schema_root = "test/support/api/schemas"
Minitest::Test.include(JsonMatchers::Minitest::Assertions)

module ActiveSupport
  class TestCase
    include MockJsonFixtures

    parallelize(workers: :number_of_processors)
    fixtures :all

    # Use this method to get the auth headers needed for a controller calling
    # authenticate_user!
    def set_auth_headers(user)
      headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
      }
      Devise::JWT::TestHelpers.auth_headers(headers, user)
    end
  end
end
