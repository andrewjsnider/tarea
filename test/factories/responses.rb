FactoryBot.define do
  factory :tarea_response, class: "Tarea::Response" do
    association :attempt, factory: :tarea_attempt
    association :prompt, factory: :tarea_prompt
    response { { "answer" => "Está contento" } }
    correct { true }
    points_earned { 1 }
    answered_at { Time.current }
  end
end
