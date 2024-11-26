class ReleaseDate < ApplicationRecord
  belongs_to :platform
  belongs_to :game

  validates :igdb_id, presence: true
end
