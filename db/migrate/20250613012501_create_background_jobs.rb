class CreateBackgroundJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :background_jobs do |t|
      t.string :job_id
      t.string :job_type
      t.string :status
      t.jsonb :result
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
