class Api::Genres::CreateFacade
  def initialize(genre_ids, twitch_bearer_token)
    @@twitch_bearer_token = twitch_bearer_token
    @@genre_ids = genre_ids || []
    @@errors = []
  end

  def find_or_create_genres
    { errors: @@errors, genres: genres }
  end

  private

  def genres
    @@genre_ids.map do |genre_id|
      Genre.find_or_initialize_by(igdb_id: genre_id) do |genre|
        next if genre.id.present?

        genre_request = set_genre_facade(genre_id).get_igdb_genre_data
        if genre_request[:error].present?
          @@errors << genre_request[:error]
          next
        end

        set_genre_properties(genre, genre_request[:igdb_genre_data])
        genre.save
        genre.errors.each { |error| @@errors << error }
      end
    end
  end

  def set_genre_facade(genre_id)
    Api::Genres::GenreRequestFacade.new(genre_id, @@twitch_bearer_token)
  end

  def set_genre_properties(genre, igdb_genre_data)
    genre.checksum = igdb_genre_data["checksum"]
    genre.igdb_url = igdb_genre_data["url"]
    genre.name = igdb_genre_data["name"]
    genre.slug = igdb_genre_data["slug"]
  end
end
