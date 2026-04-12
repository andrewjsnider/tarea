module Tarea
  class Attempt < ApplicationRecord
    self.table_name = "tarea_attempts"

    belongs_to :activity, class_name: "Tarea::Activity"
    belongs_to :assignment, class_name: "Tarea::Assignment", optional: true

    has_many :responses, class_name: "Tarea::Response", dependent: :destroy

    enum :status, {
      in_progress: 0,
      completed: 1,
      abandoned: 2
    }

    validates :user_key, presence: true

    scope :assigned, -> { where.not(assignment_id: nil) }
    scope :practice, -> { where(assignment_id: nil) }


    def answered_prompts_count
      responses.count
    end

    def total_prompts_count
      activity.prompts.count
    end

    def complete?
      completed?
    end

    def next_prompt
      answered_prompt_ids = responses.select(:prompt_id)
      activity.prompts.where.not(id: answered_prompt_ids).order(:position).first
    end
  end
end
