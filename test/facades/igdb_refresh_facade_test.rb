require "test_helper"

class IgdbRefreshFacadeTest < ActionDispatch::IntegrationTest
  include TwitchOauthTestHelper
  include IgdbApiTestHelper

  setup do
    @fields_facade = Api::Genres::IgdbFieldsFacade
    @ids = [genres(:action).igdb_id, genres(:rpg).igdb_id]
    @model = Genre
    @model_name = @model.name
    @snake_cased_model_name = @model_name.pluralize.underscore
    @twitch_bearer_token = stubbed_twitch_bearer_token
  end

  test "should update the given resources" do
    @ids.each do |id|
      stub_successful_igdb_api_request(
        "#{@snake_cased_model_name}/#{id}",
        json_mocks("igdb/#{@snake_cased_model_name}/#{id}.refresh.json"),
        @twitch_bearer_token,
      )
    end
    facade =
      IgdbRefreshFacade.new(
        fields_facade: @fields_facade,
        ids: @ids,
        model: @model,
        twitch_bearer_token: @twitch_bearer_token,
      )
    resources = facade.find_or_create_resources[:resources]
    resources.each do |resource|
      json =
        json_mocks(
          "igdb/#{@snake_cased_model_name}/#{resource.igdb_id}.refresh.json",
        )
      updated_name = JSON.parse(json)[0]["name"]
      assert_equal(resource.name, updated_name)
    end
  end
end
