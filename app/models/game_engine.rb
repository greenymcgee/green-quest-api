class GameEngine < ApplicationRecord
  has_one :game_engine_logo

  validates :igdb_id, presence: true
end
