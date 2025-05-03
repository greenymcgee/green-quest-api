class Api::Games::IndexFacade
  attr_reader :games, :params

  def initialize(params)
    @params = params
    set_games
  end

  private

  def set_games
    return @games = filtered_and_ordered(Game.published) if params[:published]

    @games = filtered_and_ordered(Game)
  end

  def filtered_and_ordered(collection)
    collection
      .by_query(params[:query])
      .by_companies(params[:companies])
      .by_genres(params[:genres])
      .by_platforms(params[:platforms])
      .includes(%i[cover platforms])
      .order(name: :asc)
  end
end
