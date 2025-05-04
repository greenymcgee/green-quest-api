class Api::HomeCarouselsController < ApplicationController
  def show
    set_carousel
    set_games
  end

  private

  def carousel_params
    params.permit(:carousel)
  end

  def set_carousel
    @carousel = carousel_params[:carousel]
  end

  def set_games
    @games =
      Game
        .published
        .includes(%i[platforms cover])
        .public_send(Game.scope_map[@carousel])
  end
end
