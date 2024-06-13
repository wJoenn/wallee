class RenameBudgetsToAccounts < ActiveRecord::Migration[7.1]
  def change
    rename_table :budgets, :accounts
    rename_column :transactions, :budget_id, :account_id
  end
end
