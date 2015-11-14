class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :zaim_id
      t.string :name
      t.date :modified
      t.integer :sort
      t.string :active
      t.string :zaim_local_id
      t.string :zaim_parent_account_id

      t.timestamps null: false
    end
  end
end
