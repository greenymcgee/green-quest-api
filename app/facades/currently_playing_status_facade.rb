class CurrentlyPlayingStatusFacade
  def self.call(game, params)
    return if should_skip_processing?(game, params)

    if game.published_at.blank?
      return "Cannot mark an unpublished game as currently playing"
    end

    Game.unset_currently_playing!
    params.delete(:last_played_date)
    game.assign_attributes(last_played_date: Date.today)
    :ok
  end

  private

  def self.should_skip_processing?(game, params)
    !truthy_param?(params) || game.currently_playing?
  end

  def self.truthy_param?(params)
    ActiveModel::Type::Boolean.new.cast(params[:currently_playing])
  end
end
