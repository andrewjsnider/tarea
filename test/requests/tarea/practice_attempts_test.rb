require "test_helper"

module Tarea
  class PracticeAttemptsTest < ActionDispatch::IntegrationTest
    def setup
      @user = Struct.new(:id).new(123)
      stub_current_user(123)

      @activity = FactoryBot.create(
        :tarea_activity,
        kind: :practice,
        title: "Practice 1"
      )

      @prompt_1 = FactoryBot.create(
        :tarea_prompt,
        activity: @activity,
        position: 1,
        text: "quiere",
        options: ["wants", "has", "is"],
        answer_key: ["wants"]
      )

      @prompt_2 = FactoryBot.create(
        :tarea_prompt,
        activity: @activity,
        position: 2,
        text: "un profesor",
        options: ["a professor", "a student", "a school"],
        answer_key: ["a professor"]
      )
    end

    def test_show_creates_attempt_and_renders_first_prompt
      get "/tarea/practice/#{@activity.id}"

      assert_response :success

      attempt = Tarea::Attempt.find_by(user_key: @user.id.to_s, activity: @activity)

      assert attempt.present?
      assert_match @prompt_1.text, response.body
    end

    def test_show_reuses_existing_in_progress_attempt
      attempt = FactoryBot.create(
        :tarea_attempt,
        user_key: @user.id.to_s,
        activity: @activity,
        status: :in_progress
      )

      get "/tarea/practice/#{@activity.id}"

      assert_response :success
      assert_equal attempt.id, Tarea::Attempt.find_by(user_key: @user.id.to_s, activity: @activity).id
    end

    def test_create_response_submits_answer_and_shows_feedback
      get "/tarea/practice/#{@activity.id}"
      attempt = Tarea::Attempt.find_by(user_key: @user.id.to_s, activity: @activity)

      post "/tarea/practice/#{@activity.id}/responses", params: {
        prompt_id: @prompt_1.id,
        submitted_answer: "wants"
      }

      assert_response :success
      assert_equal 1, attempt.reload.responses.count
      assert_match @prompt_1.text, response.body
      assert_match "Correct", response.body
      assert_match "Next", response.body
    end

    def test_advance_moves_to_next_prompt
      get "/tarea/practice/#{@activity.id}"

      post "/tarea/practice/#{@activity.id}/responses", params: {
        prompt_id: @prompt_1.id,
        submitted_answer: "wants"
      }

      post "/tarea/practice/#{@activity.id}/advance"

      assert_response :success
      assert_match @prompt_2.text, response.body
    end

    def test_final_answer_shows_finish_before_completion
      get "/tarea/practice/#{@activity.id}"

      post "/tarea/practice/#{@activity.id}/responses", params: {
        prompt_id: @prompt_1.id,
        submitted_answer: "wants"
      }

      post "/tarea/practice/#{@activity.id}/advance"

      post "/tarea/practice/#{@activity.id}/responses", params: {
        prompt_id: @prompt_2.id,
        submitted_answer: "a professor"
      }

      assert_response :success
      assert_match @prompt_2.text, response.body
      assert_match "Correct", response.body
      assert_match "Finish", response.body
    end

    def test_finish_after_last_prompt_renders_complete
      get "/tarea/practice/#{@activity.id}"
      attempt = Tarea::Attempt.find_by(user_key: @user.id.to_s, activity: @activity)

      post "/tarea/practice/#{@activity.id}/responses", params: {
        prompt_id: @prompt_1.id,
        submitted_answer: "wants"
      }

      post "/tarea/practice/#{@activity.id}/advance"

      post "/tarea/practice/#{@activity.id}/responses", params: {
        prompt_id: @prompt_2.id,
        submitted_answer: "a professor"
      }

      post "/tarea/practice/#{@activity.id}/advance"

      assert_response :success
      assert_equal "completed", attempt.reload.status
      assert_match "Practice complete", response.body
    end
  end
end
