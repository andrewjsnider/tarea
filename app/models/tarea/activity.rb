module Tarea
  class Activity < ApplicationRecord
    self.table_name = "tarea_activities"

    has_many :assignments, class_name: "Tarea::Assignment", dependent: :destroy
    has_many :attempts, class_name: "Tarea::Attempt", dependent: :destroy

    enum :kind, {
      reading_comprehension: 0,
      practice: 1,
      grammar: 2,
      listening: 3
    }

    validates :kind, presence: true
  end
end
