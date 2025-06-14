class CreateSwipeFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :swipe_files do |t|
      t.string :title
      t.text :content
      t.text :tags
      t.string :brand
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
