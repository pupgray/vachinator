# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 15) }
    password_digest { BCrypt::Password.create(password) }
    verified { true }

    trait :unverified do
      verified { false }
    end
  end
end
