class Api::Games::UpdateFacade
  def self.call(game, params)
    new(game, params).call
  end

  attr_reader :game, :params

  def initialize(game, params)
    @game = game
    @params = params.dup
    @reasons = []
  end

  def call
    check_currently_playing_status
    return @reasons if @reasons.any?

    assign_game_attributes
    return :ok if game.save

    false
  end

  private

  def check_currently_playing_status
    result = CurrentlyPlayingStatusFacade.call(game, params)
    @reasons << result if result.is_a?(String)
  end

  def assign_game_attributes
    review_value = params.delete(:review)
    game.assign_attributes(params)
    game.review = sanitize(review_value) || ""
  end

  def sanitize(value)
    ActionController::Base.helpers.sanitize(value)
  end
end
