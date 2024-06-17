class AddCategoryToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :category, :integer
    Account.find_each { |account| account.update(category: account.main ? 0 : 1) }
    change_column_null :accounts, :category, false
    remove_column :accounts, :main
  end
end
