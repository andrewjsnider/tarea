module Tarea
  class Assignment < ApplicationRecord
    self.table_name = "tarea_assignments"

    belongs_to :activity, class_name: "Tarea::Activity"
    has_many :attempts, class_name: "Tarea::Attempt", dependent: :nullify
  end
end
