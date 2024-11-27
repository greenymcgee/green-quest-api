class PlatformLogo < ApplicationRecord
  validates :igdb_id, presence: true
end
