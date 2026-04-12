module Tarea
  class Response < ApplicationRecord
    self.table_name = "tarea_responses"

    belongs_to :attempt, class_name: "Tarea::Attempt"
    belongs_to :prompt, class_name: "Tarea::Prompt"

    validates :response, presence: true
  end
end
