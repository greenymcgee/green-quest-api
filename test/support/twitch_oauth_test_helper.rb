module TwitchOauthTestHelper
  def twitch_oauth_access_token
    "asdlfkj424089"
  end

  def stub_successful_twitch_oauth_request
    stub_request(:post, url).with(request_params).to_return(
      body: {
        access_token: twitch_oauth_access_token,
        expires_in: "4_778_283",
        token_type: "bearer",
      }.to_json,
      status: 200,
    )
  end

  def stub_twitch_oauth_request_failure(status = 400, message = "Bad request")
    stub_request(:post, url).with(request_params).to_return(
      body: { message: message }.to_json,
      status: status,
    )
  end

  private

  def host
    URI(Rails.configuration.igdb_oauth_url).host
  end

  def request_params
    {
      body: {
        client_id: Rails.application.credentials.igdb_client_id!,
        client_secret: Rails.application.credentials.igdb_client_secret_key!,
        grant_type: "client_credentials",
      }.to_json,
      headers: {
        Accept: "application/json",
        "Accept-Encoding": "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
        "Content-type": "application/json",
        Host: host,
        "User-Agent": "Ruby",
      },
    }
  end

  def url
    Rails.configuration.igdb_oauth_url
  end
end
