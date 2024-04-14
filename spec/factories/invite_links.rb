FactoryBot.define do
  factory :invite_link do
    code { nil }
    user { user }
    team { team }
    spaces_remaining { 1 }
    expires_at { Time.now + 2.hours }
  end
end
