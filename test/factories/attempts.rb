FactoryBot.define do
  factory :tarea_attempt, class: "Tarea::Attempt" do
    user_key { "user-123" }
    association :activity, factory: :tarea_activity
    assignment { nil }
    status { :in_progress }
    score { 0 }
    points_possible { 0 }
    xp_earned { 0 }
    started_at { Time.current }
    completed_at { nil }

    trait :assigned do
      association :assignment, factory: :tarea_assignment
    end

    trait :completed do
      status { :completed }
      score { 3 }
      points_possible { 3 }
      xp_earned { 3 }
      completed_at { Time.current }
    end
  end
end
