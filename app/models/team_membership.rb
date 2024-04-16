class TeamMembership < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :joined_with, class_name: 'InviteLink', optional: true

  validates :user, uniqueness: { scope: :team }
end
