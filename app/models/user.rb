class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :teams, dependent: :destroy, inverse_of: :captain
  has_many :invite_links, dependent: :nullify
  has_many :compatriots, class_name: 'User', through: :teams, source: :members
  has_many :matches, through: :teams

  validates :username, presence: true, uniqueness: true, format: { with: /[\w-]*/ }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 7 }

  has_secure_password

  normalizes :username, with: ->(username) { username.strip.downcase }
  normalizes :email, with: ->(email) { email.strip.downcase }

  generates_token_for(:email_verification, expires_in: 2.days) { email }
  generates_token_for(:password_reset, expires_in: 20.minutes) { password_salt.last(10) }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  def to_s
    username
  end
end
