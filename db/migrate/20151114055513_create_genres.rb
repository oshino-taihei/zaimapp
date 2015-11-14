class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :zaim_id
      t.string :zaim_category_id
      t.string :name
      t.integer :sort
      t.string :active
      t.date :modified
      t.string :zaim_parent_genre_id
      t.string :zaim_local_id

      t.timestamps null: false
    end
  end
end
