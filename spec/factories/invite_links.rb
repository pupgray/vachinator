FactoryBot.define do
  factory :invite_link, class: InviteLink do
    code { nil }
    user
    team
    spaces_remaining { 1 }
    expires_at { Time.now + 2.hours }
  end
end
