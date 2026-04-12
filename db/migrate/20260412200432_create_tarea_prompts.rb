class CreateTareaPrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :tarea_prompts do |t|
      t.references :activity, null: false, foreign_key: { to_table: :tarea_activities }
      t.integer :kind, null: false
      t.text :text, null: false
      t.json :options, null: false, default: []
      t.json :answer_key, null: false, default: []
      t.integer :position, null: false

      t.timestamps
    end

    add_index :tarea_prompts, [:activity_id, :position], unique: true
    add_index :tarea_prompts, :kind
  end
end
