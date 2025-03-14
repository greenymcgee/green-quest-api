class Company < ApplicationRecord
  has_one :company_logo, dependent: :destroy
  has_many :involved_companies

  validates :igdb_id, presence: true
end
