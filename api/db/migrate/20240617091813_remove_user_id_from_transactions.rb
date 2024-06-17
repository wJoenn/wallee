class RemoveUserIdFromTransactions < ActiveRecord::Migration[7.1]
  def change
    remove_reference :transactions, :user
  end
end
