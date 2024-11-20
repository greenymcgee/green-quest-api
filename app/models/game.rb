class Game < ApplicationRecord
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :platforms

  validates :igdb_id, presence: true
end
