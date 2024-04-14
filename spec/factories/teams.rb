FactoryBot.define do
  factory :team do
    name { Faker::Team.name }

    association :captain, factory: :user
  end
end
