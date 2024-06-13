FactoryBot.define do
  factory :account do
    name { "My account" }

    user { association :user }
  end
end
