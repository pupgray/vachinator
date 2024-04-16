# frozen_string_literal: true

FactoryBot.define do
  factory :herd do
    name { Faker::Team.name }

    captain factory: %i[user]
  end
end
