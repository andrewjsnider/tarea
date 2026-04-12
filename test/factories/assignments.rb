FactoryBot.define do
  factory :tarea_assignment, class: "Tarea::Assignment" do
    title { "Week 1 Reading" }
    association :activity, factory: :tarea_activity
    opens_on { Time.current }
    due_on { 1.week.from_now }
    published { false }
    grading_scheme { {} }
  end
end
