class Artwork < ApplicationRecord
  has_and_belongs_to_many :games

  validates :igdb_id, presence: true
end
