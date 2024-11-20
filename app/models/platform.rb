class Platform < ApplicationRecord
  validates :igdb_id, presence: true
end
