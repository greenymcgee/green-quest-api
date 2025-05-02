require "test_helper"

class PublishableGameFacadeTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess::FixtureFile

  test "#unpublishable_reasons should all missing attributes as unpublishable reasons" do
    game = Game.new
    facade = PublishableGameFacade.new(game)
    reasons = facade.unpublishable_reasons
    assert_includes reasons, "Banner image can't be blank"
    assert_includes reasons, "Estimated first played date can't be blank"
    assert_includes reasons, "Featured video id can't be blank"
    assert_includes reasons, "Last played date can't be blank"
    assert_includes reasons, "Rating can't be blank"
    assert_includes reasons, "Review can't be blank"
    assert_includes reasons, "Review title can't be blank"
  end

  test "#unpublishable_reasons should return an empty array when all publishable fields are present" do
    game =
      Game.create!(
        estimated_first_played_date: Date.new(2020, 1, 1),
        featured_video_id: "abc123",
        igdb_id: 4848,
        last_played_date: Date.new(2021, 1, 1),
        review: "This is a great game!",
        review_title: "Amazing Adventure",
      )
    game.banner_image = fixture_file_upload("banner_image.webp", "image/webp")
    game.save!
    facade = PublishableGameFacade.new(game)
    reasons = facade.unpublishable_reasons
    assert_equal [], reasons
  end

  test "#unpublishable_reasons should return only missing fields as reasons" do
    game =
      Game.create!(
        featured_video_id: "abc123",
        igdb_id: 4848,
        review: "Some review text",
        review_title: "Title here",
      )
    game.banner_image = fixture_file_upload("banner_image.webp", "image/webp")
    game.save!
    facade = PublishableGameFacade.new(game)
    reasons = facade.unpublishable_reasons
    assert_includes reasons, "Estimated first played date can't be blank"
    assert_includes reasons, "Last played date can't be blank"
    assert_equal 2, reasons.count
  end

  test "#publishable? should return false when required fields are missing" do
    game = Game.new
    facade = PublishableGameFacade.new(game)
    assert_not facade.publishable?
  end

  test "#publishable? should return true when all required fields are present" do
    game =
      Game.create!(
        estimated_first_played_date: Date.new(2020, 1, 1),
        featured_video_id: "abc123",
        igdb_id: 4848,
        last_played_date: Date.new(2021, 1, 1),
        review: "This is a great game!",
        review_title: "Amazing Adventure",
        rating: 90,
      )
    game.banner_image = fixture_file_upload("banner_image.webp", "image/webp")
    game.save!
    facade = PublishableGameFacade.new(game)
    assert facade.publishable?
  end

  test "#publishable? should return false when only some fields are present" do
    game =
      Game.create!(
        featured_video_id: "abc123",
        igdb_id: 4848,
        review: "Some review text",
        review_title: "Title here",
      )
    game.banner_image = fixture_file_upload("banner_image.webp", "image/webp")
    game.save!
    facade = PublishableGameFacade.new(game)
    assert_not facade.publishable?
  end
end
