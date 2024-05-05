FactoryBot.define do
  factory :sub_category do
    name { "My sub category" }

    category { association :category }
    user { association :user }
  end
end
