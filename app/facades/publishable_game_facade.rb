class PublishableGameFacade
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def unpublishable_reasons
    publishable_methods.map { |method| send(method) }.compact
  end

  def publishable?
    game.featured_video_id.present? && game.banner_image.present? &&
      game.review.present? && game.review_title.present? &&
      game.rating.present? && game.estimated_first_played_date.present? &&
      game.last_played_date.present?
  end

  private

  def publishable_methods
    %i[
      banner_image_message
      estimated_first_played_date_message
      featured_video_id_message
      last_played_date_message
      rating_message
      review_message
      review_title_message
    ]
  end

  def banner_image_message
    return unless game.banner_image.blank?

    "Banner image can't be blank"
  end

  def estimated_first_played_date_message
    return unless game.estimated_first_played_date.blank?

    "Estimated first played date can't be blank"
  end

  def featured_video_id_message
    return unless game.featured_video_id.blank?

    "Featured video id can't be blank"
  end

  def last_played_date_message
    return unless game.last_played_date.blank?

    "Last played date can't be blank"
  end

  def rating_message
    return unless game.review.blank?

    "Rating can't be blank"
  end

  def review_message
    return unless game.review.blank?

    "Review can't be blank"
  end

  def review_title_message
    return unless game.review_title.blank?

    "Review title can't be blank"
  end
end
