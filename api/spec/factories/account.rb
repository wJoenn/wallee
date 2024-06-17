FactoryBot.define do
  factory :account do
    category { :budget }
    name { "My account" }

    user { association :user }
  end
end
