class GameEngine < ApplicationRecord
  validates :igdb_id, presence: true
end
