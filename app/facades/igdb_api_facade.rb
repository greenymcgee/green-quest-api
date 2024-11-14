class IgdbApiFacade
  def initialize(pathname, twitch_oauth_token)
    @@api_url = "#{Rails.configuration.igdb_api_url}/#{pathname}?fields=*"
    @@twitch_oauth_token = twitch_oauth_token
  end

  def get_igdb_api_resource
    request_resource
    begin
      unless Net::HTTPSuccess === @@response
        raise StandardError.new @@response.body
      end

      { response: @@response }
    rescue StandardError => error
      { error: error }
    end
  end

  private

  def request_resource
    set_uri
    set_http
    set_request
    set_request_properties
    set_response
  end

  def set_uri
    @@uri = URI(@@api_url)
  end

  def set_http
    @@http = Net::HTTP.new(@@uri.host, @@uri.port)
    @@http.use_ssl = true
  end

  def set_request
    @@request = Net::HTTP::Get.new(@@uri)
  end

  def set_request_properties
    @@request["Accept"] = "application/json"
    @@request["Authorization"] = @@twitch_oauth_token
    @@request["Client-ID"] = Rails.application.credentials.igdb_client_id!
    @@request["Content-Type"] = "application/json"
  end

  def set_response
    @@response = @@http.request(@@request)
  end
end
