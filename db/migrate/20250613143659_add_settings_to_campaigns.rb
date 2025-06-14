class AddSettingsToCampaigns < ActiveRecord::Migration[8.0]
  def change
    add_column :campaigns, :settings, :jsonb, default: {}
    add_index :campaigns, :settings, using: :gin
  end
end
