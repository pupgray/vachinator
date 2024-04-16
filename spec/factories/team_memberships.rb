# frozen_string_literal: true

FactoryBot.define do
  factory :herd_membership do
    user
    herd

    joined_with factory: %i[invite_link]
  end
end
