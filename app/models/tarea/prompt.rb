module Tarea
  class Prompt < ApplicationRecord
    self.table_name = "tarea_prompts"

    belongs_to :activity, class_name: "Tarea::Activity"
    has_many :responses, class_name: "Tarea::Response", dependent: :destroy

    enum :kind, {
      multiple_choice: 0,
      true_false: 1,
      fill_blank: 2,
      short_answer: 3
    }

    validates :kind, presence: true
    validates :text, presence: true
    validates :position, presence: true
  end
end
