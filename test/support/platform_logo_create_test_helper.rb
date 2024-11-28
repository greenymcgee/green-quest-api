require "./test/support/igdb_api_test_helper.rb"

module PlatformLogoCreateTestHelper
  include IgdbApiTestHelper

  def stubbed_platform_logo_ids
    [106, 235, 595]
  end

  def stub_successful_platform_logo_responses
    stubbed_platform_logo_ids.each do |id|
      stub_successful_igdb_api_request(
        "platform_logos/#{id}",
        json_mocks("igdb/platform_logos/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_platform_logo_request_failures
    stubbed_platform_logo_ids.each do |id|
      stub_igdb_api_request_failure("platform_logos/#{id}")
    end
  end

  def stub_platform_logo_responses(with_platform_logo_failures)
    return stub_platform_logo_request_failures if with_platform_logo_failures

    stub_successful_platform_logo_responses
  end
end
