class CreateCampaignTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :campaign_templates do |t|
      t.string :name
      t.string :brand
      t.string :goal
      t.text :description
      t.jsonb :structure
      t.jsonb :metadata

      t.timestamps
    end
  end
end
