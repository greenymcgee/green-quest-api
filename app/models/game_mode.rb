class GameMode < ApplicationRecord
  validates :igdb_id, presence: true
end
