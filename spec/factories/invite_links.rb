# frozen_string_literal: true

FactoryBot.define do
  factory :invite_link, class: 'InviteLink' do
    code { nil }
    user
    herd
    spaces_remaining { 1 }
    expires_at { 2.hours.from_now }
  end
end
