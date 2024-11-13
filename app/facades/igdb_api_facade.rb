class IgdbApiFacade
  def initialize(pathname, twitch_oauth_token)
    @@api_url = "#{Rails.configuration.igdb_api_url}/#{pathname}"
    @@twitch_oauth_token = twitch_oauth_token
  end

  def get_igdb_api_resource
    begin
      set_uri
      set_http
      set_request
      set_request_properties
      set_response
      unless Net::HTTPSuccess === @@response
        raise StandardError.new @@response.body
      end

      @@response
    rescue StandardError => error
      error
    end
  end

  private

  def set_uri
    @@uri = URI(@@api_url)
  end

  def set_http
    @@http = Net::HTTP.new(@@uri.host, @@uri.port)
    @@http.use_ssl = true
  end

  def set_request
    @@request = Net::HTTP::Post.new(@@uri)
  end

  def set_request_properties
    @@request["Accept"] = "application/json"
    @@request["Authorization"] = @@twitch_oauth_token
    @@request["Content-Type"] = "application/json"
    @@request.body = { fields: "*" }.to_json
  end

  def set_response
    @@response = @@http.request(@@request)
  end
end
