require "test_helper"

module Tarea
  module Attempts
    class SubmitResponseTest < ActiveSupport::TestCase
      def setup
        @activity = FactoryBot.create(:tarea_activity)
        @prompt = FactoryBot.create(
          :tarea_prompt,
          activity: @activity,
          kind: :multiple_choice,
          answer_key: ["Está contento"],
          options: ["Está triste", "Está contento", "Está enojado"],
          position: 1
        )
        @attempt = FactoryBot.create(:tarea_attempt, activity: @activity)
      end

      def test_creates_correct_response_for_correct_answer
        result = Tarea::Attempts::SubmitResponse.call(
          attempt: @attempt,
          prompt: @prompt,
          submitted_answer: "Está contento"
        )

        response = @attempt.responses.find_by(prompt: @prompt)

        assert response.present?
        assert_equal true, response.correct
        assert_equal 1, response.points_earned
        assert_equal({ "answer" => "Está contento" }, response.response)
        assert_equal true, result.correct?
      end

      def test_creates_incorrect_response_for_wrong_answer
        result = Tarea::Attempts::SubmitResponse.call(
          attempt: @attempt,
          prompt: @prompt,
          submitted_answer: "Está triste"
        )

        response = @attempt.responses.find_by(prompt: @prompt)

        assert response.present?
        assert_equal false, response.correct
        assert_equal 0, response.points_earned
        assert_equal false, result.correct?
      end

      def test_does_not_create_duplicate_response_for_same_prompt
        Tarea::Attempts::SubmitResponse.call(
          attempt: @attempt,
          prompt: @prompt,
          submitted_answer: "Está triste"
        )

        assert_no_difference("Tarea::Response.count") do
          Tarea::Attempts::SubmitResponse.call(
            attempt: @attempt,
            prompt: @prompt,
            submitted_answer: "Está contento"
          )
        end
      end

      def test_raises_error_when_prompt_does_not_belong_to_attempt_activity
        other_activity = FactoryBot.create(:tarea_activity)
        other_prompt = FactoryBot.create(:tarea_prompt, activity: other_activity)

        assert_raises(ArgumentError) do
          Tarea::Attempts::SubmitResponse.call(
            attempt: @attempt,
            prompt: other_prompt,
            submitted_answer: "whatever"
          )
        end
      end
    end
  end
end
