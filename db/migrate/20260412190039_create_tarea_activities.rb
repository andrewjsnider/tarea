class CreateTareaActivities < ActiveRecord::Migration[7.0]
  def change
      create_table :tarea_activities do |t|
        t.string :title
        t.integer :kind, null: false
        t.integer :xp_value, null: false, default: 0
        t.json :metadata, null: false, default: {}

        t.timestamps
      end

      add_index :tarea_activities, :kind
    end
end
