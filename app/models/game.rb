class Game < ApplicationRecord
  has_and_belongs_to_many :age_ratings
  has_and_belongs_to_many :artworks
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :platforms
  has_many :involved_companies

  validates :igdb_id, presence: true

  def developers
    developer_involved_companies = involved_companies.where(is_developer: true)
    developer_involved_companies.map do |involved_company|
      involved_company.company
    end
  end

  def porters
    porter_involved_companies = involved_companies.where(is_porter: true)
    porter_involved_companies.map do |involved_company|
      involved_company.company
    end
  end

  def publishers
    publisher_involved_companies = involved_companies.where(is_publisher: true)
    publisher_involved_companies.map do |involved_company|
      involved_company.company
    end
  end

  def supporters
    supporter_involved_companies = involved_companies.where(is_supporter: true)
    supporter_involved_companies.map do |involved_company|
      involved_company.company
    end
  end
end
