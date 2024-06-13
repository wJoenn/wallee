class AddMainToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :main, :boolean, null: false, default: false
  end
end
