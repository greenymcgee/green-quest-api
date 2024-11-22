class Api::Games::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(game, igdb_game_data)
    @@game = game
    @@igdb_game_data = igdb_game_data
  end

  def populate_game_fields
    @@game.update(
      bundle_ids: bundle_ids,
      dlc_ids: dlc_ids,
      expanded_game_ids: expanded_game_ids,
      expansion_ids: expansion_ids,
      fork_ids: fork_ids,
      category_enum: category_enum,
      checksum: checksum,
      first_release_date: first_release_date,
      igdb_url: igdb_url,
      name: name,
      parent_game_id: parent_game_id,
      port_ids: port_ids,
      remake_ids: remake_ids,
      remaster_ids: remaster_ids,
      similar_game_ids: similar_game_ids,
      slug: slug,
      status: status,
      standalone_expansion_ids: standalone_expansion_ids,
      storyline: storyline,
      summary: summary,
      version_parent_id: version_parent_id,
      version_title: version_title,
    )
  end

  private

  def bundle_ids
    get_present_value(@@game.bundle_ids, @@igdb_game_data["bundles"])
  end

  def dlc_ids
    get_present_value(@@game.dlc_ids, @@igdb_game_data["dlcs"])
  end

  def expanded_game_ids
    get_present_value(
      @@game.expanded_game_ids,
      @@igdb_game_data["expanded_games"],
    )
  end

  def expansion_ids
    get_present_value(@@game.expansion_ids, @@igdb_game_data["expansions"])
  end

  def fork_ids
    get_present_value(@@game.fork_ids, @@igdb_game_data["forks"])
  end

  def parent_game_id
    get_present_value(@@game.parent_game_id, @@igdb_game_data["parent_game"])
  end

  def port_ids
    get_present_value(@@game.port_ids, @@igdb_game_data["ports"])
  end

  def remake_ids
    get_present_value(@@game.remake_ids, @@igdb_game_data["remakes"])
  end

  def remaster_ids
    get_present_value(@@game.remaster_ids, @@igdb_game_data["remasters"])
  end

  def similar_game_ids
    get_present_value(
      @@game.similar_game_ids,
      @@igdb_game_data["similar_games"],
    )
  end

  def standalone_expansion_ids
    get_present_value(
      @@game.standalone_expansion_ids,
      @@igdb_game_data["standalone_expansions"],
    )
  end

  def version_parent_id
    get_present_value(
      @@game.version_parent_id,
      @@igdb_game_data["version_parent"],
    )
  end

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
    return unless first_release_date_unix_timestamp.present?

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
