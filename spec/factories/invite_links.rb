FactoryBot.define do
  factory :invite_link do
    code { Faker::Alphanumeric.alphanumeric(number: 10) }
    user
    team
    spaces_remaining { 1 }
    expires_at { Time.now + 2.hours }
  end
end
