FactoryBot.define do
  factory :herd do
    name { Faker::Team.name }

    association :captain, factory: :user
  end
end
