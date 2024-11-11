class Game < ApplicationRecord
  validates :igdb_id, presence: true
end
