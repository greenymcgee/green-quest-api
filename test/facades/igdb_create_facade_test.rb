require "test_helper"

class IgdbCreateFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper

  setup do
    @fields_facade = Api::AgeRatings::IgdbFieldsFacade
    @ids = JSON.parse(json_mocks("igdb/game.json")).first["age_ratings"]
    @model = AgeRating
    @model_name = @model.name
    @snake_cased_model_name = @model_name.pluralize.underscore
    @twitch_oauth_token = "Bearer asdlfkh"
  end

  test "should create new resources" do
    @ids.each do |id|
      stub_successful_igdb_api_request(
        "#{@snake_cased_model_name}/#{id}",
        json_mocks("igdb/#{@snake_cased_model_name}/#{id}.json"),
        @twitch_oauth_token,
      )
    end
    assert_difference("#{@model_name}.count", +@ids.count) do
      facade =
        IgdbCreateFacade.new(
          fields_facade: @fields_facade,
          ids: @ids,
          model: @model,
          twitch_bearer_token: @twitch_oauth_token,
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
          twitch_bearer_token: @twitch_oauth_token,
        )
      facade.find_or_create_resources
    end
  end

  test "should return successfully found or created resources" do
    @ids.each do |id|
      stub_successful_igdb_api_request(
        "#{@snake_cased_model_name}/#{id}",
        json_mocks("igdb/#{@snake_cased_model_name}/#{id}.json"),
        @twitch_oauth_token,
      )
    end
    facade =
      IgdbCreateFacade.new(
        fields_facade: @fields_facade,
        ids: @ids,
        model: @model,
        twitch_bearer_token: @twitch_oauth_token,
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
        twitch_bearer_token: @twitch_oauth_token,
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
      @twitch_oauth_token,
    )
    facade =
      IgdbCreateFacade.new(
        fields_facade: @fields_facade,
        ids: [nil],
        model: @model,
        twitch_bearer_token: @twitch_oauth_token,
      )
    request = facade.find_or_create_resources
    errors = request[:errors]
    errors.each { |error| assert_equal(error.message, "can't be blank") }
  end

  test "should handle undefined ids gracefully" do
    stub_successful_igdb_api_request(
      "#{@snake_cased_model_name}/#{nil}",
      json_mocks("igdb/#{@snake_cased_model_name}/49238.json"),
      @twitch_oauth_token,
    )
    facade =
      IgdbCreateFacade.new(
        fields_facade: @fields_facade,
        ids: nil,
        model: @model,
        twitch_bearer_token: @twitch_oauth_token,
      )
    request = facade.find_or_create_resources
    assert_equal request[:resources], []
  end
end
