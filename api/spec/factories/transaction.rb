FactoryBot.define do
  factory :transaction do
    value { 1 }

    user { association :user }

    after(:build) do |transaction|
      transaction.account = transaction.user.main_account unless transaction.account.present?
    end
  end
end
