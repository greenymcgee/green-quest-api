class Game < ApplicationRecord
  has_and_belongs_to_many :genres

  validates :igdb_id, presence: true
end
