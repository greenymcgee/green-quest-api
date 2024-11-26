class Game < ApplicationRecord
  has_and_belongs_to_many :age_ratings
  has_many :artworks
  has_and_belongs_to_many :genres
  has_many :involved_companies
  has_and_belongs_to_many :platforms
  has_many :screenshots

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
