class Screenshot < ApplicationRecord
  belongs_to :game

  validates :igdb_id, presence: true
end
