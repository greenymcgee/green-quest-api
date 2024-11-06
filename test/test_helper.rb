ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "devise/jwt/test_helpers"
require "minitest/autorun"
require "json_matchers/minitest/assertions"

JsonMatchers.schema_root = "test/support/api/schemas"
Minitest::Test.include(JsonMatchers::Minitest::Assertions)

module ActiveSupport
  class TestCase
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
