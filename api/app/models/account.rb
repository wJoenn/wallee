class Account < ApplicationRecord
  belongs_to :user

  has_many :transactions, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  def balance
    transactions.sum(&:value)
  end

  def serialize(include = false)
    account = { balance:, description:, id:, name: }
    account[:transactions] = transactions if include

    account
  end
end
