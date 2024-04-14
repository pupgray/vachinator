class InviteLink < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates :expires_at, comparison: { greater_than: Time.now }, presence: true
  validates :spaces_remaining, comparison: { greater_than: 0 }, presence: true

  generates_token_for(:code, expires_in: 1.year) { valid? }

  before_create do
    unless code.present?
      self.code = generate_token_for :code
      save
    end
  end
end
