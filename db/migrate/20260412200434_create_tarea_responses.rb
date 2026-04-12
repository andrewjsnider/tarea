class CreateTareaResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :tarea_responses do |t|
      t.references :attempt, null: false, foreign_key: { to_table: :tarea_attempts }
      t.references :prompt, null: false, foreign_key: { to_table: :tarea_prompts }
      t.json :response, null: false, default: {}
      t.boolean :correct
      t.integer :points_earned, null: false, default: 0
      t.datetime :answered_at

      t.timestamps
    end

    add_index :tarea_responses, [:attempt_id, :prompt_id], unique: true
  end
end
