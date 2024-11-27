class Website < ApplicationRecord
  validates :igdb_id, presence: true
end
