require "test_helper"

module Tarea
  class AttemptTest < ActiveSupport::TestCase
    def setup
      @attempt = FactoryBot.build(:tarea_attempt)
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
  end
end
