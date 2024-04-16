FactoryBot.define do
  factory :herd_membership do
    user
    herd

    association :joined_with, factory: :invite_link
  end
end
