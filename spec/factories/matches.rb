FactoryBot.define do
  factory :match do
    herd
    name { Faker::Sport.unusual_sport }
    starts_at { 1.day.ago }
    ends_at { 3.days.from_now }
  end
end
