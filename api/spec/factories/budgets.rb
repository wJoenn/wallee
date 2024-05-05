FactoryBot.define do
  factory :budget do
    name { "My budget" }

    user { association :user }
  end
end
