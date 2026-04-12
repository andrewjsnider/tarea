class CreateTareaAttempts < ActiveRecord::Migration[7.0]
  def change
    create_table :tarea_attempts do |t|
      t.string :user_key, null: false
      t.references :activity, null: false, foreign_key: { to_table: :tarea_activities }
      t.references :assignment, null: true, foreign_key: { to_table: :tarea_assignments }
      t.integer :status, null: false, default: 0
      t.integer :score, null: false, default: 0
      t.integer :points_possible, null: false, default: 0
      t.integer :xp_earned, null: false, default: 0
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end

    add_index :tarea_attempts, [:user_key, :activity_id]
    add_index :tarea_attempts, [:user_key, :assignment_id]
    add_index :tarea_attempts, :status
    add_index :tarea_attempts, :completed_at
  end
end
