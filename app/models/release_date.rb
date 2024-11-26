class ReleaseDate < ApplicationRecord
  belongs_to :platform
  belongs_to :game

  delegate :name, to: :platform, prefix: :platform
  validates :igdb_id, presence: true
end
