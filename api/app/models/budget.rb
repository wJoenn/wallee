class Budget < ApplicationRecord
  belongs_to :user

  has_many :transactions, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  def balance
    transactions.sum(&:value)
  end

  def serialize
    { balance:, description:, id:, name:, transactions: }
  end
end
