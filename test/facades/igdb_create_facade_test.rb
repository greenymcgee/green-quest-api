require "test_helper"

class IgdbCreateFacadeTest < ActionDispatch::IntegrationTest
  include TwitchOauthTestHelper
  include IgdbApiTestHelper

  setup do
    @fields_facade = Api::AgeRatings::IgdbFieldsFacade
    @ids = igdb_game_data["age_ratings"]
    @model = AgeRating
    @model_name = @model.name
    @snake_cased_model_name = @model_name.pluralize.underscore
    @twitch_bearer_token = stubbed_twitch_bearer_token
  end

  test "should create new resources" do
    @ids.each do |id|
      stub_successful_igdb_api_request(
        "#{@snake_cased_model_name}/#{id}",
        json_mocks("igdb/#{@snake_cased_model_name}/#{id}.json"),
        @twitch_bearer_token,
      )
    end
    assert_difference("#{@model_name}.count", +@ids.count) do
      facade =
        IgdbCreateFacade.new(
          fields_facade: @fields_facade,
          ids: @ids,
          model: @model,
          twitch_bearer_token: @twitch_bearer_token,
        )
      facade.find_or_create_resources
    end
  end

  test "should not create resources when the igdb request fails" do
    @ids.each do |id|
      stub_igdb_api_request_failure("#{@snake_cased_model_name}/#{id}")
    end
    assert_difference("#{@model_name}.count", +0) do
      facade =
        IgdbCreateFacade.new(
          fields_facade: @fields_facade,
          ids: @ids,
          model: @model,
          twitch_bearer_token: @twitch_bearer_token,
        )
      facade.find_or_create_resources
    end
  end

  test "should return successfully found or created resources" do
    @ids.each do |id|
      stub_successful_igdb_api_request(
        "#{@snake_cased_model_name}/#{id}",
        json_mocks("igdb/#{@snake_cased_model_name}/#{id}.json"),
        @twitch_bearer_token,
      )
    end
    facade =
      IgdbCreateFacade.new(
        fields_facade: @fields_facade,
        ids: @ids,
        model: @model,
        twitch_bearer_token: @twitch_bearer_token,
      )
    igdb_ids = facade.find_or_create_resources[:resources].map(&:igdb_id)
    assert_equal igdb_ids, @ids
  end

  test "should return errors for any failed igdb api requests" do
    @ids.each do |id|
      stub_igdb_api_request_failure("#{@snake_cased_model_name}/#{id}")
    end
    facade =
      IgdbCreateFacade.new(
        fields_facade: @fields_facade,
        ids: @ids,
        model: @model,
        twitch_bearer_token: @twitch_bearer_token,
      )
    errors = facade.find_or_create_resources[:errors]
    errors.each_with_index do |error, index|
      assert_equal(error, { @ids[index] => { "message" => "Not authorized" } })
    end
  end

  test "should return errors for any failed resource creations" do
    stub_successful_igdb_api_request(
      "#{@snake_cased_model_name}/#{nil}",
      json_mocks("igdb/#{@snake_cased_model_name}/49238.json"),
      @twitch_bearer_token,
    )
    facade =
      IgdbCreateFacade.new(
        fields_facade: @fields_facade,
        ids: [nil],
        model: @model,
        twitch_bearer_token: @twitch_bearer_token,
      )
    request = facade.find_or_create_resources
    errors = request[:errors]
    errors.each { |error| assert_equal(error.message, "can't be blank") }
  end

  test "should handle undefined ids gracefully" do
    stub_successful_igdb_api_request(
      "#{@snake_cased_model_name}/#{nil}",
      json_mocks("igdb/#{@snake_cased_model_name}/49238.json"),
      @twitch_bearer_token,
    )
    facade =
      IgdbCreateFacade.new(
        fields_facade: @fields_facade,
        ids: nil,
        model: @model,
        twitch_bearer_token: @twitch_bearer_token,
      )
    request = facade.find_or_create_resources
    assert_equal request[:resources], []
  end

  test "should take an optional callback for belongs_to relationships" do
    igdb_game_data["artworks"].each do |id|
      stub_successful_igdb_api_request(
        "artworks/#{id}",
        json_mocks("igdb/artworks/#{id}.json"),
        @twitch_bearer_token,
      )
    end
    game = games(:super_metroid)
    facade =
      IgdbCreateFacade.new(
        fields_facade: Igdb::ImageFieldsFacade,
        ids: igdb_game_data["artworks"],
        model: Artwork,
        twitch_bearer_token: @twitch_bearer_token,
      )
    request =
      facade.find_or_create_resources(->(resource) { resource.game = game })
    assert_equal request[:resources], game.artworks
  end

  test "should populate resource fields" do
    resource_id = @ids.first
    stub_successful_igdb_api_request(
      "#{@snake_cased_model_name}/#{resource_id}",
      json_mocks("igdb/#{@snake_cased_model_name}/#{resource_id}.json"),
      @twitch_bearer_token,
    )
    IgdbCreateFacade.new(
      fields_facade: @fields_facade,
      ids: [resource_id],
      model: @model,
      twitch_bearer_token: @twitch_bearer_token,
    ).find_or_create_resources
    resource_json =
      json_mocks("igdb/#{@snake_cased_model_name}/#{resource_id}.json")
    resource_data = JSON.parse(resource_json).first
    assert_equal(
      resource_data["rating_cover_url"],
      @model.last.rating_cover_url,
    )
  end

  test "should not attempt to create when the igdb_data is blank" do
    @ids.each do |id|
      stub_successful_igdb_api_request(
        "#{@snake_cased_model_name}/#{id}",
        [].to_json,
        @twitch_bearer_token,
      )
    end
    assert_difference("#{@model_name}.count", +0) do
      IgdbCreateFacade.new(
        fields_facade: @fields_facade,
        ids: @ids,
        model: @model,
        twitch_bearer_token: @twitch_bearer_token,
      ).find_or_create_resources
    end
  end
end
