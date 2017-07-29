class CreateActivityLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :activity_logs do |t|
      t.string :loggable_type
      t.integer :loggable_id
      t.text :changes_hash

      t.timestamps
    end
  end
end
