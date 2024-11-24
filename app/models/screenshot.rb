class Screenshot < ApplicationRecord
  validates :igdb_id, presence: true
end
