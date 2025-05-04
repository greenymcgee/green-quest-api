class Company < ApplicationRecord
  has_one :company_logo, dependent: :destroy
  has_many :involved_companies

  validates :igdb_id, presence: true

  scope(
    :with_games,
    -> do
      joins(involved_companies: :game)
        .merge(Game.published)
        .distinct
        .order(:name)
    end,
  )
end
