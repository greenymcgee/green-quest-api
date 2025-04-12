class Game < ApplicationRecord
  mount_uploader :banner_image, BannerImageUploader

  has_and_belongs_to_many :age_ratings
  has_many :artworks, dependent: :destroy
  has_one :cover, dependent: :destroy
  has_and_belongs_to_many :franchises
  has_and_belongs_to_many :game_engines
  has_and_belongs_to_many :game_modes
  has_and_belongs_to_many :genres
  has_many :involved_companies, dependent: :destroy
  has_and_belongs_to_many :platforms
  has_and_belongs_to_many :player_perspectives
  has_many :release_dates, dependent: :destroy
  has_many :screenshots, dependent: :destroy
  has_and_belongs_to_many :themes
  has_many :websites, dependent: :destroy
  has_many :game_videos, dependent: :destroy

  scope(
    :by_query,
    ->(query) do
      where("name ILIKE ?", "%#{sanitize_sql_like(query)}%") if query.present?
    end,
  )

  scope(
    :by_companies,
    ->(company_ids) do
      return if company_ids.blank?

      joins(:involved_companies).where(
        involved_companies: {
          company_id: company_ids,
        },
      ).distinct
    end,
  )

  scope(
    :by_genres,
    ->(genre_ids) do
      return if genre_ids.blank?

      joins(:genres).where(genres: { id: genre_ids }).distinct
    end,
  )

  scope(
    :by_platforms,
    ->(platform_ids) do
      return if platform_ids.blank?

      joins(:platforms).where(platforms: { id: platform_ids }).distinct
    end,
  )

  validates :igdb_id, presence: true

  def developers
    developer_involved_companies =
      involved_companies.where(is_developer: true).includes([:company])
    developer_involved_companies.map do |involved_company|
      involved_company.company
    end
  end

  def porters
    porter_involved_companies =
      involved_companies.where(is_porter: true).includes([:company])
    porter_involved_companies.map do |involved_company|
      involved_company.company
    end
  end

  def published?
    return false if published_at.blank?

    published_at < Time.current
  end

  def publishers
    publisher_involved_companies =
      involved_companies.where(is_publisher: true).includes([:company])
    publisher_involved_companies.map do |involved_company|
      involved_company.company
    end
  end

  def supporters
    supporter_involved_companies =
      involved_companies.where(is_supporter: true).includes([:company])
    supporter_involved_companies.map do |involved_company|
      involved_company.company
    end
  end
end
