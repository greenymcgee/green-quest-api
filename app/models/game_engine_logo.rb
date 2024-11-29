class GameEngineLogo < ApplicationRecord
  belongs_to :game_engine

  validates :igdb_id, presence: true
end
