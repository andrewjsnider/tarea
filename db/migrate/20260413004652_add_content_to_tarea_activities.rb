class AddContentToTareaActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :tarea_activities, :content, :text
  end
end
