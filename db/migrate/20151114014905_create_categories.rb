class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :zaim_id
      t.string :mode
      t.string :name
      t.integer :sort
      t.string :active
      t.date :modified
      t.string :zaim_parent_category_id
      t.string :zaim_local_id

      t.timestamps null: false
    end
  end
end
