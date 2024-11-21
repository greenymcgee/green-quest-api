class Company < ApplicationRecord
  validates :igdb_id, presence: true
end
