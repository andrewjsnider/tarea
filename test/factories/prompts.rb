FactoryBot.define do
  factory :tarea_prompt, class: "Tarea::Prompt" do
    association :activity, factory: :tarea_activity
    kind { :multiple_choice }
    text { "¿Cómo está Iván?" }
    options { ["Está triste", "Está contento", "Está enojado"] }
    answer_key { ["Está contento"] }
    sequence(:position) { |n| n }
  end
end
