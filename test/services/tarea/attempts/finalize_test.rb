require "test_helper"

module Tarea
  module Attempts
    class FinalizeTest < ActiveSupport::TestCase
      def setup
        @activity = FactoryBot.create(:tarea_activity)

        @prompt_1 = FactoryBot.create(
          :tarea_prompt,
          activity: @activity,
          position: 1,
          answer_key: ["correct 1"]
        )

        @prompt_2 = FactoryBot.create(
          :tarea_prompt,
          activity: @activity,
          position: 2,
          answer_key: ["correct 2"]
        )

        @attempt = FactoryBot.create(
          :tarea_attempt,
          activity: @activity,
          status: :in_progress,
          score: 0,
          points_possible: 0,
          completed_at: nil
        )
      end

      def test_does_not_complete_attempt_if_not_all_prompts_answered
        FactoryBot.create(
          :tarea_response,
          attempt: @attempt,
          prompt: @prompt_1,
          points_earned: 1
        )

        result = Tarea::Attempts::Finalize.call(attempt: @attempt)

        @attempt.reload

        assert_equal false, result.completed?
        assert_equal "in_progress", @attempt.status
        assert_nil @attempt.completed_at
        assert_equal 0, @attempt.score
        assert_equal 0, @attempt.points_possible
      end

      def test_completes_attempt_when_all_prompts_answered
        FactoryBot.create(
          :tarea_response,
          attempt: @attempt,
          prompt: @prompt_1,
          points_earned: 1
        )

        FactoryBot.create(
          :tarea_response,
          attempt: @attempt,
          prompt: @prompt_2,
          points_earned: 0
        )

        result = Tarea::Attempts::Finalize.call(attempt: @attempt)

        @attempt.reload

        assert_equal true, result.completed?
        assert_equal "completed", @attempt.status
        assert_not_nil @attempt.completed_at
        assert_equal 1, @attempt.score
        assert_equal 2, @attempt.points_possible
      end

      def test_returns_completed_false_if_attempt_has_no_activity_prompts
        empty_activity = FactoryBot.create(:tarea_activity)
        empty_attempt = FactoryBot.create(:tarea_attempt, activity: empty_activity)

        result = Tarea::Attempts::Finalize.call(attempt: empty_attempt)

        empty_attempt.reload

        assert_equal false, result.completed?
        assert_equal "in_progress", empty_attempt.status
        assert_nil empty_attempt.completed_at
      end
    end
  end
end
