# frozen_string_literal: true

class Herd < ApplicationRecord
  belongs_to :captain, class_name: 'User', optional: false
  has_many :invite_links, dependent: :nullify
  has_many :memberships, class_name: 'HerdMembership', dependent: :destroy
  has_many :members, class_name: 'User', through: :memberships, source: :user, inverse_of: :herds
  has_many :matches, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 },
                   format: { with: /\A[\w\s]+\z/, message: I18n.t('only_allows_letters') }

  after_create do
    members << captain
    save
  end

  def has?(user)
    members.exists?(user.id)
  end
end
