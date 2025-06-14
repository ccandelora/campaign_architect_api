class AddStatusAndPerformanceFieldsToCampaigns < ActiveRecord::Migration[8.0]
  def change
    add_column :campaigns, :status, :integer, default: 0, null: false
    add_column :campaigns, :predicted_performance, :jsonb
    add_column :campaigns, :actual_performance, :jsonb

    add_index :campaigns, :status
    add_index :campaigns, :predicted_performance, using: :gin
    add_index :campaigns, :actual_performance, using: :gin
  end
end
