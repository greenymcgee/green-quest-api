class Artwork < ApplicationRecord
  validates :igdb_id, presence: true
end
