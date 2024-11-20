class Api::Games::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(game, igdb_game_data)
    @@game = game
    @@igdb_game_data = igdb_game_data
  end

  def populate_game_fields
    @@game.update(
      category_enum: category_enum,
      checksum: checksum,
      first_release_date: first_release_date,
      igdb_url: igdb_url,
      name: name,
      slug: slug,
      status: status,
      storyline: storyline,
      summary: summary,
      version_title: version_title,
    )
  end

  private

  def category_enum
    get_present_value(@@game.category_enum, @@igdb_game_data["category"])
  end

  def checksum
    get_present_value(@@game.checksum, @@igdb_game_data["checksum"])
  end

  def first_release_date_unix_timestamp
    @@igdb_game_data["first_release_date"]
  end

  def first_release_date_to_datetime
    Time.at(first_release_date_unix_timestamp).utc.to_datetime
  end

  def first_release_date
    get_present_value(@@game.first_release_date, first_release_date_to_datetime)
  end

  def igdb_url
    get_present_value(@@game.igdb_url, @@igdb_game_data["url"])
  end

  def name
    get_present_value(@@game.name, @@igdb_game_data["name"])
  end

  def slug
    get_present_value(@@game.slug, @@igdb_game_data["slug"])
  end

  def status
    get_present_value(@@game.status, @@igdb_game_data["status"])
  end

  def storyline
    get_present_value(@@game.storyline, @@igdb_game_data["storyline"])
  end

  def summary
    get_present_value(@@game.summary, @@igdb_game_data["summary"])
  end

  def version_title
    get_present_value(@@game.version_title, @@igdb_game_data["version_title"])
  end
end
