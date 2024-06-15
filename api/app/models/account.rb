class Account < ApplicationRecord
  belongs_to :user

  has_many :transactions

  validates :name, presence: true, uniqueness: { scope: :user_id }

  before_destroy :manage_transactions

  def balance
    transactions.sum(&:value)
  end

  def serialize(include = false)
    account = { balance:, description:, id:, name:, main: }
    account[:transactions] = transactions if include

    account
  end

  private

  def manage_transactions
    if !main && user.main_account.present?
      transactions.update_all(account_id: user.main_account.id)
    else
      transactions.destroy_all
    end
  end
end
