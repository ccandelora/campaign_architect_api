class CreateCampaigns < ActiveRecord::Migration[8.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :brand
      t.text :goal
      t.jsonb :structure
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
