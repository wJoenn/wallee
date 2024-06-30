def timestamp(time)
  Time.current.change(year: time.year, month: time.month, day: time.day)
end

unless Rails.env.production?
  User.destroy_all

  user = User.create(email: "user@example.com", password: "password")
  fuel = Account.create(category: :budget, name: "Fuel", user:)
  groceries = Account.create(category: :budget, name: "Groceries", user:)
  saving = Account.create(category: :saving, name: "Saving", user:)

  (-18..6).each do |index|
    [
      { description: "salary", transacted_at: timestamp(index.month.from_now.beginning_of_month), value: 2_000_00 },
      { description: "rent", transacted_at: timestamp(index.month.from_now.beginning_of_month), value: -500_00 },
      { description: "subscriptions", transacted_at: timestamp(index.month.from_now.beginning_of_month), value: -100_00 },
      { description: "fuel budget top up", transacted_at: timestamp(index.month.from_now.beginning_of_month), value: -100_00 },
      { description: "groceries budget top up", transacted_at: timestamp(index.month.from_now.beginning_of_month), value: -200_00 },
      { description: "saving top up", transacted_at: timestamp(index.month.from_now.beginning_of_month), value: -1_000_00 },
    ].each do |transaction|
      description, transacted_at, value = transaction.values_at(:description, :transacted_at, :value)
      Transaction.create(account: user.main_account, description:, transacted_at:, value:)
    end
  end

  [
    { description: "top up", transacted_at: timestamp(2.months.ago.beginning_of_month), value: 100_00 },
    { description: nil, transacted_at: timestamp(2.months.ago.change(day: 3)), value: -60_00 },
    { description: nil, transacted_at: timestamp(2.months.ago.change(day: 5)), value: -60_00 },
    { description: "top up", transacted_at: timestamp(1.month.ago.beginning_of_month), value: 100_00 },
    { description: nil, transacted_at: timestamp(1.month.ago.change(day: 3)), value: -60_00 },
    { description: nil, transacted_at: timestamp(1.month.ago.change(day: 5)), value: -60_00 },
    { description: "top up", transacted_at: timestamp(Time.current.beginning_of_month), value: 100_00 },
    { description: nil, transacted_at: timestamp(Time.current.change(day: 3)), value: -60_00 },
    { description: nil, transacted_at: timestamp(Time.current.change(day: 5)), value: -60_00 }
  ].each do |transaction|
    description, transacted_at, value = transaction.values_at(:description, :transacted_at, :value)
    Transaction.create(account: fuel, description:, transacted_at:, value:)
  end

  [
    { description: "top up", transacted_at: timestamp(2.months.ago.beginning_of_month), value: 203_00 },
    { description: nil, transacted_at: timestamp(2.months.ago.change(day: 1)), value: -45_00 },
    { description: nil, transacted_at: timestamp(2.months.ago.change(day: 7)), value: -50_00 },
    { description: nil, transacted_at: timestamp(2.months.ago.change(day: 14)), value: -30_00 },
    { description: nil, transacted_at: timestamp(2.months.ago.change(day: 21)), value: -30_00 },
    { description: "top up", transacted_at: timestamp(1.month.ago.beginning_of_month), value: 152_00 },
    { description: nil, transacted_at: timestamp(1.month.ago.change(day: 1)), value: -50_00 },
    { description: nil, transacted_at: timestamp(1.month.ago.change(day: 7)), value: -50_00 },
    { description: nil, transacted_at: timestamp(1.months.ago.change(day: 14)), value: -60_00 },
    { description: nil, transacted_at: timestamp(1.months.ago.change(day: 21)), value: -40_00 },
    { description: "top up", transacted_at: timestamp(Time.current.beginning_of_month), value: 200_00 },
    { description: nil, transacted_at: timestamp(Time.current.change(day: 1)), value: -25_00 },
    { description: nil, transacted_at: timestamp(Time.current.change(day: 7)), value: -80_00 }
  ].each do |transaction|
    description, transacted_at, value = transaction.values_at(:description, :transacted_at, :value)
    Transaction.create(account: groceries, description:, transacted_at:, value:)
  end

  [
    { description: "top up", transacted_at: timestamp(Time.current.beginning_of_month), value: 1_000_00 },
  ].each do |transaction|
    description, transacted_at, value = transaction.values_at(:description, :transacted_at, :value)
    Transaction.create(account: saving, description:, transacted_at:, value:)
  end
end
