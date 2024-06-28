class RemoveSubCategoryIdFromTransactions < ActiveRecord::Migration[7.1]
  def change
    remove_reference :transactions, :sub_category
  end
end
