class Game < ApplicationRecord
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :platforms
  has_many :involved_companies

  validates :igdb_id, presence: true
end
