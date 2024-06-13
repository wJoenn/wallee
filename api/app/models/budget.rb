class Budget < ApplicationRecord
  belongs_to :user

  has_many :transactions, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  def balance
    transactions.sum(&:value)
  end

  def serialize(include = false)
    budget = { balance:, description:, id:, name: }
    budget[:transactions] = transactions if include

    budget
  end
end
