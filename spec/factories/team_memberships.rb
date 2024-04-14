FactoryBot.define do
  factory :team_membership do
    user
    team

    association :joined_with, factory: :invite_link
  end
end
