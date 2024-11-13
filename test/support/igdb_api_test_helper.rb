module IgdbApiTestHelper
  def stub_successful_igdb_api_request(pathname, response_body)
    params = igdb_request_params(pathname)
    response = { body: response_body, status: 200 }
    stub_request(:post, igdb_url(pathname)).with(params).to_return(response)
  end

  def stub_igdb_api_request_failure(pathname)
    params = igdb_request_params(pathname)
    response = { body: igdb_api_failure_response_body, status: 401 }
    stub_request(:post, igdb_url(pathname)).with(params).to_return(response)
  end

  def igdb_api_failure_response_body
    { message: "Not authorized" }.to_json
  end

  def twitch_oauth_bearer_token
    "Bearer asdlfkj1234"
  end

  private

  def igdb_request_params(pathname)
    {
      headers: {
        Accept: "application/json",
        Authorization: twitch_oauth_bearer_token,
        "Content-type": "application/json",
      },
      body: { fields: "*" }.to_json,
    }
  end

  def igdb_url(pathname)
    "#{Rails.configuration.igdb_api_url}/#{pathname}"
  end
end
