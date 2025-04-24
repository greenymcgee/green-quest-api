class CurrentlyPlayingStatusFacade
  def self.call(game, params)
    return unless self.is_param_truthy?(params) && !game.currently_playing

    Game.unset_currently_playing!
    params.delete(:last_played_date)
    game.assign_attributes(last_played_date: Date.today)
  end

  private

  def self.is_param_truthy?(params)
    ActiveModel::Type::Boolean.new.cast(params[:currently_playing])
  end
end
