class Account < ApplicationRecord
  ATTRIBUTES = %i[balance category description executed_transactions id name planned_transactions]

  belongs_to :user

  has_many :executed_transactions, -> { executed }, class_name: "Transaction"
  has_many :planned_transactions, -> { planned }, class_name: "Transaction"
  has_many :transactions

  enum category: { main: 0, budget: 1, saving: 2 }

  validates :category, :name, presence: true
  validates :name, uniqueness: { scope: :user_id }
  validate :uniqueness_of_main_account

  before_destroy :manage_transactions

  def balance
    executed_transactions.sum(&:value)
  end

  private

  def manage_transactions
    if !main? && user.main_account.present?
      transactions.update_all(account_id: user.main_account.id)
    else
      transactions.destroy_all
    end
  end

  def uniqueness_of_main_account
    errors.add(:category, :taken) if main? && user && user.accounts.where.not(id:).main.exists?
  end
end
