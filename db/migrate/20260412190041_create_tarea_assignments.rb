class CreateTareaAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :tarea_assignments do |t|
      t.string :title
      t.references :activity, null: false, foreign_key: { to_table: :tarea_activities }
      t.datetime :opens_on
      t.datetime :due_on
      t.boolean :published, null: false, default: false
      t.json :grading_scheme, null: false, default: {}

      t.timestamps
    end

    add_index :tarea_assignments, :due_on
    add_index :tarea_assignments, :published
  end
end
