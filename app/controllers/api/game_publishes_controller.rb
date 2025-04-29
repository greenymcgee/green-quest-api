class Api::GamePublishesController < ApplicationController
  def create
    authenticate_user!
    set_game
    set_facade
    return render_unprocessable_publish unless @facade.publishable?

    @game.update!(published_at: Time.current)
    render json: {}, status: :ok
  end

  def destroy
    authenticate_user!
    set_game
    set_facade
    @game.update!(published_at: nil)
    render json: {}, status: :ok
  end

  private

  def render_unprocessable_publish
    render :unpublishable_game, status: :unprocessable_entity
  end

  def set_facade
    @facade = PublishableGameFacade.new(@game)
  end

  def set_game
    @game = authorize Game.find_by!(slug: params[:slug])
  end
end
