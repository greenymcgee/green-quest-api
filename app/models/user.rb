class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise(
    :database_authenticatable,
    :registerable,
    :trackable,
    :recoverable,
    :rememberable,
    :validatable,
    :jwt_authenticatable,
    jwt_revocation_strategy: self,
  )

  validates :email, presence: true
  validates :roles, presence: true
  validates :username, presence: true
  validate :password_complexity

  def admin?
    roles.include? USER_ROLES[:admin]
  end

  def password_complexity
    return if password.blank? || password =~ PASSWORD_COMPLEXITY_REGEX

    errors.add(:password, PASSWORD_COMPLEXITY_ERROR_MESSAGE)
  end
end
