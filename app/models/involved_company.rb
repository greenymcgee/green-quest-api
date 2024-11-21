class InvolvedCompany < ApplicationRecord
  belongs_to :game
  belongs_to :company

  validates :igdb_id, presence: true
end
