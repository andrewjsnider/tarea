module Tarea
  module Attempts
    class Finalize
      Result = Struct.new(:attempt, :completed?, keyword_init: true)

      def self.call(attempt:)
        new(attempt: attempt).call
      end

      def initialize(attempt:)
        @attempt = attempt
      end

      def call
        return Result.new(attempt: @attempt, completed?: false) unless completable?

        @attempt.update!(
          score: score,
          points_possible: points_possible,
          status: :completed,
          completed_at: Time.current
        )

        Result.new(attempt: @attempt, completed?: true)
      end

      private

      def prompts
        @attempt.activity.prompts.order(:position)
      end

      def responses
        @attempt.responses
      end

      def completable?
        return false if prompts.empty?
        responses.count == prompts.count
      end

      def score
        responses.sum(:points_earned)
      end

      def points_possible
        prompts.count
      end
    end
  end
end
