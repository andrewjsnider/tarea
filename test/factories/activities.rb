FactoryBot.define do
  factory :tarea_activity, class: "Tarea::Activity" do
    title { "Reading 1" }
    kind { :reading_comprehension }
    xp_value { 3 }
    metadata { {} }
  end
end
