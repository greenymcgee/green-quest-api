class Company < ApplicationRecord
  has_many :involved_companies

  validates :igdb_id, presence: true
end
