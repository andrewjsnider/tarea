require "test_helper"

module Tarea
  class ReadingAttemptsTest < ActionDispatch::IntegrationTest
    def setup
      @user = Struct.new(:id).new(123)

      Tarea::ApplicationController.class_eval do
        define_method(:current_user) do
          Struct.new(:id).new(123)
        end
      end

      @activity = FactoryBot.create(
        :tarea_activity,
        kind: :reading_comprehension,
        title: "Un diálogo",
        content: "Francisco: Hola, Iván.\nIván: Estoy muy contento."
      )

      @assignment = FactoryBot.create(
        :tarea_assignment,
        activity: @activity,
        title: "Reading 1"
      )

      @prompt_1 = FactoryBot.create(
        :tarea_prompt,
        activity: @activity,
        position: 1,
        text: "¿Cómo está Iván?",
        options: ["Está triste", "Está contento", "Está enojado"],
        answer_key: ["Está contento"]
      )

      @prompt_2 = FactoryBot.create(
        :tarea_prompt,
        activity: @activity,
        position: 2,
        text: "¿Quién habla?",
        options: ["Francisco e Iván", "Ana y Luis", "Pedro y Marta"],
        answer_key: ["Francisco e Iván"]
      )
    end

    def test_show_creates_assignment_backed_attempt_and_renders_reading
      get "/tarea/assignments/#{@assignment.id}"

      assert_response :success

      attempt = Tarea::Attempt.find_by(
        user_key: @user.id.to_s,
        activity: @activity,
        assignment: @assignment
      )

      assert attempt.present?
      assert_match @activity.title, response.body
      assert_match "Francisco: Hola, Iván.", response.body
      assert_match @prompt_1.text, response.body
    end

    def test_show_reuses_existing_in_progress_assignment_attempt
      attempt = FactoryBot.create(
        :tarea_attempt,
        user_key: @user.id.to_s,
        activity: @activity,
        assignment: @assignment,
        status: :in_progress
      )

      get "/tarea/assignments/#{@assignment.id}"

      assert_response :success
      assert_equal attempt.id, Tarea::Attempt.find_by(
        user_key: @user.id.to_s,
        activity: @activity,
        assignment: @assignment
      ).id
    end

    def test_create_response_submits_answer_and_renders_next_prompt
      get "/tarea/assignments/#{@assignment.id}"
      attempt = Tarea::Attempt.find_by(
        user_key: @user.id.to_s,
        activity: @activity,
        assignment: @assignment
      )

      post "/tarea/assignments/#{@assignment.id}/responses", params: {
        prompt_id: @prompt_1.id,
        submitted_answer: "Está contento"
      }

      assert_response :success
      assert_equal 1, attempt.reload.responses.count
      assert_match @prompt_2.text, response.body
      assert_match "Correct", response.body
    end

    def test_create_response_finalizes_attempt_when_last_prompt_answered
      get "/tarea/assignments/#{@assignment.id}"
      attempt = Tarea::Attempt.find_by(
        user_key: @user.id.to_s,
        activity: @activity,
        assignment: @assignment
      )

      post "/tarea/assignments/#{@assignment.id}/responses", params: {
        prompt_id: @prompt_1.id,
        submitted_answer: "Está contento"
      }

      post "/tarea/assignments/#{@assignment.id}/responses", params: {
        prompt_id: @prompt_2.id,
        submitted_answer: "Francisco e Iván"
      }

      assert_response :success
      assert_equal "completed", attempt.reload.status
      assert_match "Reading complete", response.body
    end
  end
end
