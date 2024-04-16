# frozen_string_literal: true

class InviteLink < ApplicationRecord
  belongs_to :user
  belongs_to :herd

  validates :expires_at, comparison: { greater_than: Time.zone.now }, presence: true, on: :create
  validates :spaces_remaining, comparison: { greater_than_or_equal_to: 0 }, presence: true

  generates_token_for(:invite_code, expires_in: 1.year) { valid?(:create) }

  after_create do
    if code.blank?
      self.code = generate_token_for :invite_code
      save
    end
  end

  def join(user)
    self.spaces_remaining -= 1
    save!
    herd.members << user
  end
end
