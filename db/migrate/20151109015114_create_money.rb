class CreateMoney < ActiveRecord::Migration
  def change
    create_table :money do |t|
      t.string :zaim_id
      t.string :zaim_user_id
      t.date :date
      t.string :mode
      t.string :zaim_category_id
      t.string :zaim_genre_id
      t.string :zaim_from_account_id
      t.string :zaim_to_account_id
      t.integer :amount
      t.string :comment
      t.string :active
      t.date :created
      t.string :currency_code
      t.string :name
      t.string :zaim_receipt_id
      t.string :zaim_place_uid
      t.string :place

      t.timestamps null: false
    end
  end
end
