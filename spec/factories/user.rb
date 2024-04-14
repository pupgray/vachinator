# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 7) }
    password_digest { BCrypt::Password.create(password) }
    verified { true }

    trait :unverified do
      verified { false }
    end
  end
end
