module IgdbApiTestHelper
  def stub_successful_igdb_api_request(pathname, response_body, bearer_token)
    params = igdb_request_params(pathname, bearer_token)
    response = { body: response_body, status: 200 }
    stub_request(:get, igdb_url(pathname)).with(params).to_return(response)
  end

  def stub_igdb_api_request_failure(pathname)
    params = igdb_request_params(pathname)
    response = { body: igdb_api_failure_response_body, status: 401 }
    stub_request(:get, igdb_url(pathname)).with(params).to_return(response)
  end

  def game_json
    json_mocks("igdb/game.json")
  end

  def igdb_game_data
    JSON.parse(game_json).first
  end

  private

  def igdb_api_failure_response_body
    { message: "Not authorized" }.to_json
  end

  def igdb_api_error
    StandardError.new(igdb_api_failure_response_body)
  end

  def igdb_request_params(pathname, bearer_token = nil)
    params = {
      headers: {
        Accept: "application/json",
        "Content-type": "application/json",
        "Client-ID": Rails.application.credentials.igdb_client_id!,
      },
    }

    return params unless bearer_token.present?

    { **params, headers: { **params[:headers], Authorization: bearer_token } }
  end

  def igdb_url(pathname)
    "#{Rails.configuration.igdb_api_url}/#{pathname}?fields=*"
  end
end
