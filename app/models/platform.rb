class Platform < ApplicationRecord
  has_and_belongs_to_many :games
  has_one :platform_logo, dependent: :destroy
  has_many :release_dates

  validates :igdb_id, presence: true

  scope(:with_games, -> { joins(:games).merge(Game.published).distinct })
end
