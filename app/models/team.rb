class Team < ApplicationRecord
  belongs_to :captain, class_name: 'User', required: true
  has_many :invite_links, dependent: :nullify
  has_many :memberships, class_name: 'TeamMembership', dependent: :destroy
  has_many :members, class_name: 'User', through: :memberships, source: :user, inverse_of: :teams
  has_many :matches, dependent: :destroy

  validates :captain, presence: true
  validates :name, presence: true, length: { maximum: 50 }, format: { with: /\A[\w\s]+\z/, message: "only allows letters" }

  after_create do
    members << captain
    save
  end
end
