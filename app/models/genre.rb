class Genre < ApplicationRecord
  validates :igdb_id, presence: true
end
