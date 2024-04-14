FactoryBot.define do
  factory :team do
    name { "MyString" }
    captain { user }
  end
end
