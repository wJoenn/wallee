FactoryBot.define do
  factory :transaction do
    value { 1 }

    user { association :user }
  end
end
