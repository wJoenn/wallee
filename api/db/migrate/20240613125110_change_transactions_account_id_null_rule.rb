class ChangeTransactionsAccountIdNullRule < ActiveRecord::Migration[7.1]
  def change
    change_column_null :transactions, :account_id, false
  end
end
