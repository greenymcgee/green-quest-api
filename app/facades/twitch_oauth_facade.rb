class TwitchOauthFacade
  def self.get_twitch_oauth_token
    begin
      set_uri
      set_http
      set_request
      set_request_properties
      set_response
      set_access_token
      set_bearer_token
      unless Net::HTTPSuccess === @@response
        raise StandardError.new @@response.body
      end

      { bearer_token: @@bearer_token }
    rescue Exception => error
      { error: error }
    end
  end

  private

  def self.set_request_properties
    @@request["Accept"] = "application/json"
    @@request["Content-Type"] = "application/json"
    @@request.body = {
      client_id: igdb_client_id,
      client_secret: igdb_client_secret,
      grant_type: "client_credentials",
    }.to_json
  end

  def self.igdb_client_id
    Rails.application.credentials.igdb_client_id!
  end

  def self.igdb_client_secret
    Rails.application.credentials.igdb_client_secret_key!
  end

  def self.set_uri
    @@uri = URI(Rails.configuration.igdb_oauth_url)
  end

  def self.set_http
    @@http = Net::HTTP.new(@@uri.host, @@uri.port)
    @@http.use_ssl = true
  end

  def self.set_request
    @@request = Net::HTTP::Post.new(@@uri)
  end

  def self.set_response
    @@response = @@http.request(@@request)
  end

  def self.set_access_token
    @@access_token = JSON.parse(@@response.body)["access_token"]
  end

  def self.set_bearer_token
    @@bearer_token = "Bearer #{@@access_token}"
  end
end
