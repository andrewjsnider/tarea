Tarea::Engine.routes.draw do
  root "dashboard#show"

  get "practice/:activity_id", to: "practice_attempts#show", as: :practice_attempt
  post "practice/:activity_id/responses", to: "practice_attempts#create_response", as: :practice_attempt_responses
end
