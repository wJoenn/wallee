class DropSubCategories < ActiveRecord::Migration[7.1]
  def change
    drop_table :sub_categories
  end
end
