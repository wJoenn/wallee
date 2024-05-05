class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.integer :value, null: false
      t.string :description
      t.datetime :transacted_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.references :budget, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :sub_category, foreign_key: true

      t.timestamps
    end
  end
end
