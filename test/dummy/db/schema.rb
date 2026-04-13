# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2026_04_13_004652) do
  create_table "tarea_activities", force: :cascade do |t|
    t.string "title"
    t.integer "kind", null: false
    t.integer "xp_value", default: 0, null: false
    t.json "metadata", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.index ["kind"], name: "index_tarea_activities_on_kind"
  end

  create_table "tarea_assignments", force: :cascade do |t|
    t.string "title"
    t.integer "activity_id", null: false
    t.datetime "opens_on"
    t.datetime "due_on"
    t.boolean "published", default: false, null: false
    t.json "grading_scheme", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_tarea_assignments_on_activity_id"
    t.index ["due_on"], name: "index_tarea_assignments_on_due_on"
    t.index ["published"], name: "index_tarea_assignments_on_published"
  end

  create_table "tarea_attempts", force: :cascade do |t|
    t.string "user_key", null: false
    t.integer "activity_id", null: false
    t.integer "assignment_id"
    t.integer "status", default: 0, null: false
    t.integer "score", default: 0, null: false
    t.integer "points_possible", default: 0, null: false
    t.integer "xp_earned", default: 0, null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_tarea_attempts_on_activity_id"
    t.index ["assignment_id"], name: "index_tarea_attempts_on_assignment_id"
    t.index ["completed_at"], name: "index_tarea_attempts_on_completed_at"
    t.index ["status"], name: "index_tarea_attempts_on_status"
    t.index ["user_key", "activity_id"], name: "index_tarea_attempts_on_user_key_and_activity_id"
    t.index ["user_key", "assignment_id"], name: "index_tarea_attempts_on_user_key_and_assignment_id"
  end

  create_table "tarea_prompts", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.integer "kind", null: false
    t.text "text", null: false
    t.json "options", default: [], null: false
    t.json "answer_key", default: [], null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id", "position"], name: "index_tarea_prompts_on_activity_id_and_position", unique: true
    t.index ["activity_id"], name: "index_tarea_prompts_on_activity_id"
    t.index ["kind"], name: "index_tarea_prompts_on_kind"
  end

  create_table "tarea_responses", force: :cascade do |t|
    t.integer "attempt_id", null: false
    t.integer "prompt_id", null: false
    t.json "response", default: {}, null: false
    t.boolean "correct"
    t.integer "points_earned", default: 0, null: false
    t.datetime "answered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attempt_id", "prompt_id"], name: "index_tarea_responses_on_attempt_id_and_prompt_id", unique: true
    t.index ["attempt_id"], name: "index_tarea_responses_on_attempt_id"
    t.index ["prompt_id"], name: "index_tarea_responses_on_prompt_id"
  end

  add_foreign_key "tarea_assignments", "tarea_activities", column: "activity_id"
  add_foreign_key "tarea_attempts", "tarea_activities", column: "activity_id"
  add_foreign_key "tarea_attempts", "tarea_assignments", column: "assignment_id"
  add_foreign_key "tarea_prompts", "tarea_activities", column: "activity_id"
  add_foreign_key "tarea_responses", "tarea_attempts", column: "attempt_id"
  add_foreign_key "tarea_responses", "tarea_prompts", column: "prompt_id"
end
