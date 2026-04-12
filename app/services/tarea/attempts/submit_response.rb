module Tarea
  module Attempts
    class SubmitResponse
      Result = Struct.new(:response, :correct?, keyword_init: true)

      def self.call(attempt:, prompt:, submitted_answer:)
        new(attempt: attempt, prompt: prompt, submitted_answer: submitted_answer).call
      end

      def initialize(attempt:, prompt:, submitted_answer:)
        @attempt = attempt
        @prompt = prompt
        @submitted_answer = submitted_answer
      end

      def call
        validate_prompt_belongs_to_attempt_activity!
        existing_response = @attempt.responses.find_by(prompt: @prompt)

        return Result.new(response: existing_response, correct?: existing_response.correct) if existing_response

        correct = answer_correct?
        response = @attempt.responses.create!(
          prompt: @prompt,
          response: { "answer" => @submitted_answer },
          correct: correct,
          points_earned: correct ? 1 : 0,
          answered_at: Time.current
        )

        Result.new(response: response, correct?: correct)
      end

      private

      def validate_prompt_belongs_to_attempt_activity!
        return if @prompt.activity_id == @attempt.activity_id

        raise ArgumentError, "Prompt does not belong to attempt activity"
      end

      def answer_correct?
        @prompt.answer_key.include?(@submitted_answer)
      end
    end
  end
end
