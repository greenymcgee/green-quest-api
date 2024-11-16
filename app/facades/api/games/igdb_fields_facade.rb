class Api::Games::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(game, igdb_game_data)
    @@game = game
    @@igdb_game_data = igdb_game_data
  end

  def populate_game_fields
    @@game.update(
      age_rating_ids: age_rating_ids,
      alternative_name_ids: alternative_name_ids,
      artwork_ids: artwork_ids,
      bundle_ids: bundle_ids,
      category_enum: category_enum,
      checksum: checksum,
      collection_id: collection_id,
      collection_ids: collection_ids,
      cover_id: cover_id,
      dlc_ids: dlc_ids,
      expanded_game_ids: expanded_game_ids,
      expansion_ids: expansion_ids,
      external_game_ids: external_game_ids,
      first_release_date: first_release_date,
      fork_ids: fork_ids,
      franchise_id: franchise_id,
      franchise_ids: franchise_ids,
      game_engine_ids: game_engine_ids,
      game_localization_ids: game_localization_ids,
      game_mode_ids: game_mode_ids,
      genre_ids: genre_ids,
      igdb_url: igdb_url,
      involved_company_ids: involved_company_ids,
      keyword_ids: keyword_ids,
      language_support_ids: language_support_ids,
      multiplayer_mode_ids: multiplayer_mode_ids,
      name: name,
      parent_game_id: parent_game_id,
      platform_ids: platform_ids,
      player_perspective_ids: player_perspective_ids,
      port_ids: port_ids,
      release_date_ids: release_date_ids,
      remake_ids: remake_ids,
      remaster_ids: remaster_ids,
      screenshot_ids: screenshot_ids,
      similar_game_ids: similar_game_ids,
      slug: slug,
      standalone_expansion_ids: standalone_expansion_ids,
      status: status,
      storyline: storyline,
      summary: summary,
      tag_ids: tag_ids,
      theme_ids: theme_ids,
      version_parent_id: version_parent_id,
      version_title: version_title,
      video_ids: video_ids,
      website_ids: website_ids,
    )
  end

  private

  def age_rating_ids
    get_present_value @@game.age_rating_ids, @@igdb_game_data["age_ratings"]
  end

  def alternative_name_ids
    get_present_value(
      @@game.alternative_name_ids,
      @@igdb_game_data["alternative_names"],
    )
  end

  def artwork_ids
    get_present_value(@@game.artwork_ids, @@igdb_game_data["artworks"])
  end

  def bundle_ids
    get_present_value(@@game.bundle_ids, @@igdb_game_data["bundles"])
  end

  def category_enum
    get_present_value(@@game.category_enum, @@igdb_game_data["category"])
  end

  def checksum
    get_present_value(@@game.checksum, @@igdb_game_data["checksum"])
  end

  def collection_id
    get_present_value(@@game.collection_id, @@igdb_game_data["collection"])
  end

  def collection_ids
    get_present_value(@@game.collection_ids, @@igdb_game_data["collections"])
  end

  def cover_id
    get_present_value(@@game.cover_id, @@igdb_game_data["cover"])
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

  def external_game_ids
    get_present_value(
      @@game.external_game_ids,
      @@igdb_game_data["external_games"],
    )
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

  def fork_ids
    get_present_value(@@game.fork_ids, @@igdb_game_data["forks"])
  end

  def franchise_id
    get_present_value(@@game.franchise_id, @@igdb_game_data["franchise"])
  end

  def franchise_ids
    get_present_value(@@game.franchise_ids, @@igdb_game_data["franchises"])
  end

  def game_engine_ids
    get_present_value(@@game.game_engine_ids, @@igdb_game_data["game_engines"])
  end

  def game_localization_ids
    get_present_value(
      @@game.game_localization_ids,
      @@igdb_game_data["game_localizations"],
    )
  end

  def game_mode_ids
    get_present_value(@@game.game_mode_ids, @@igdb_game_data["game_modes"])
  end

  def genre_ids
    get_present_value(@@game.genre_ids, @@igdb_game_data["genres"])
  end

  def igdb_url
    get_present_value(@@game.igdb_url, @@igdb_game_data["url"])
  end

  def involved_company_ids
    get_present_value(
      @@game.involved_company_ids,
      @@igdb_game_data["involved_companies"],
    )
  end

  def keyword_ids
    get_present_value(@@game.keyword_ids, @@igdb_game_data["keywords"])
  end

  def language_support_ids
    get_present_value(
      @@game.language_support_ids,
      @@igdb_game_data["language_supports"],
    )
  end

  def multiplayer_mode_ids
    get_present_value(
      @@game.multiplayer_mode_ids,
      @@igdb_game_data["multiplayer_modes"],
    )
  end

  def name
    get_present_value(@@game.name, @@igdb_game_data["name"])
  end

  def parent_game_id
    get_present_value(@@game.parent_game_id, @@igdb_game_data["parent_game"])
  end

  def platform_ids
    get_present_value(@@game.platform_ids, @@igdb_game_data["platforms"])
  end

  def player_perspective_ids
    get_present_value(
      @@game.player_perspective_ids,
      @@igdb_game_data["player_perspectives"],
    )
  end

  def port_ids
    get_present_value(@@game.port_ids, @@igdb_game_data["ports"])
  end

  def release_date_ids
    get_present_value(
      @@game.release_date_ids,
      @@igdb_game_data["release_dates"],
    )
  end

  def remake_ids
    get_present_value(@@game.remake_ids, @@igdb_game_data["remakes"])
  end

  def remaster_ids
    get_present_value(@@game.remaster_ids, @@igdb_game_data["remasters"])
  end

  def screenshot_ids
    get_present_value(@@game.screenshot_ids, @@igdb_game_data["screenshots"])
  end

  def similar_game_ids
    get_present_value(
      @@game.similar_game_ids,
      @@igdb_game_data["similar_games"],
    )
  end

  def slug
    get_present_value(@@game.slug, @@igdb_game_data["slug"])
  end

  def standalone_expansion_ids
    get_present_value(
      @@game.standalone_expansion_ids,
      @@igdb_game_data["standalone_expansions"],
    )
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

  def tag_ids
    get_present_value(@@game.tag_ids, @@igdb_game_data["tags"])
  end

  def theme_ids
    get_present_value(@@game.theme_ids, @@igdb_game_data["themes"])
  end

  def version_parent_id
    get_present_value(
      @@game.version_parent_id,
      @@igdb_game_data["version_parent"],
    )
  end

  def version_title
    get_present_value(@@game.version_title, @@igdb_game_data["version_title"])
  end

  def video_ids
    get_present_value(@@game.video_ids, @@igdb_game_data["videos"])
  end

  def website_ids
    get_present_value(@@game.website_ids, @@igdb_game_data["websites"])
  end
end
