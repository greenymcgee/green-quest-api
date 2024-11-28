class PlatformLogo < ApplicationRecord
  belongs_to :platform

  validates :igdb_id, presence: true
end
