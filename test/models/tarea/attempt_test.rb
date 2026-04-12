require "test_helper"

module Tarea
  class AttemptTest < ActiveSupport::TestCase
    def setup
      @activity = FactoryBot.create(:tarea_activity)
      @prompt_1 = FactoryBot.create(:tarea_prompt, activity: @activity, position: 1)
      @prompt_2 = FactoryBot.create(:tarea_prompt, activity: @activity, position: 2)
      @prompt_3 = FactoryBot.create(:tarea_prompt, activity: @activity, position: 3)

      @attempt = FactoryBot.create(:tarea_attempt, activity: @activity)
    end

    def test_valid_with_user_key_and_activity
      assert @attempt.valid?
    end

    def test_requires_user_key
      @attempt.user_key = nil

      refute @attempt.valid?
      assert_includes @attempt.errors[:user_key], "can't be blank"
    end

    def test_requires_activity
      @attempt.activity = nil

      refute @attempt.valid?
      assert_includes @attempt.errors[:activity], "must exist"
    end

    def test_assignment_is_optional
      @attempt.assignment = nil

      assert @attempt.valid?
    end

    def test_assigned_scope_returns_only_assigned_attempts
      assigned_attempt = FactoryBot.create(:tarea_attempt, :assigned)
      practice_attempt = FactoryBot.create(:tarea_attempt)

      assert_includes Tarea::Attempt.assigned, assigned_attempt
      refute_includes Tarea::Attempt.assigned, practice_attempt
    end

    def test_practice_scope_returns_only_unassigned_attempts
      assigned_attempt = FactoryBot.create(:tarea_attempt, :assigned)
      practice_attempt = FactoryBot.create(:tarea_attempt)

      assert_includes Tarea::Attempt.practice, practice_attempt
      refute_includes Tarea::Attempt.practice, assigned_attempt
    end

    def test_answered_prompts_count_returns_response_count
      assert_equal 0, @attempt.answered_prompts_count

      FactoryBot.create(:tarea_response, attempt: @attempt, prompt: @prompt_1)
      assert_equal 1, @attempt.reload.answered_prompts_count
    end

    def test_total_prompts_count_returns_activity_prompt_count
      assert_equal 3, @attempt.total_prompts_count
    end

    def test_complete_returns_false_when_status_is_not_completed
      assert_equal false, @attempt.complete?
    end

    def test_complete_returns_true_when_status_is_completed
      @attempt.update!(status: :completed, completed_at: Time.current)

      assert_equal true, @attempt.complete?
    end

    def test_next_prompt_returns_first_unanswered_prompt
      assert_equal @prompt_1, @attempt.next_prompt

      FactoryBot.create(:tarea_response, attempt: @attempt, prompt: @prompt_1)
      assert_equal @prompt_2, @attempt.reload.next_prompt

      FactoryBot.create(:tarea_response, attempt: @attempt, prompt: @prompt_2)
      assert_equal @prompt_3, @attempt.reload.next_prompt
    end

    def test_next_prompt_returns_nil_when_all_prompts_answered
      FactoryBot.create(:tarea_response, attempt: @attempt, prompt: @prompt_1)
      FactoryBot.create(:tarea_response, attempt: @attempt, prompt: @prompt_2)
      FactoryBot.create(:tarea_response, attempt: @attempt, prompt: @prompt_3)

      assert_nil @attempt.reload.next_prompt
    end
  end
end
