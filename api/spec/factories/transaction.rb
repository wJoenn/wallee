FactoryBot.define do
  factory :transaction do
    value { 1 }

    account { association :account }
  end
end
