class Cover < ApplicationRecord
  validates :igdb_id, presence: true
end
