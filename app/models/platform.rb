class Platform < ApplicationRecord
  has_and_belongs_to_many :games
  has_many :release_dates

  validates :igdb_id, presence: true
end
