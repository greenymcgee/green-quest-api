class GameEngine < ApplicationRecord
  has_and_belongs_to_many :games
  has_one :game_engine_logo

  validates :igdb_id, presence: true
end
