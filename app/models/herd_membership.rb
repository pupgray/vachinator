# frozen_string_literal: true

class HerdMembership < ApplicationRecord
  belongs_to :user
  belongs_to :herd
  belongs_to :joined_with, class_name: 'InviteLink', optional: true

  validates :user, uniqueness: { scope: :herd }
end
