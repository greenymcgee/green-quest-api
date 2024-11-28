class CompanyLogo < ApplicationRecord
  belongs_to :company

  validates :igdb_id, presence: true
end
