class AgeRating < ApplicationRecord
  validates :igdb_id, presence: true
end