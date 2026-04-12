require "test_helper"

module Tarea
  class AssignmentTest < ActiveSupport::TestCase
    def setup
      @assignment = FactoryBot.build(:tarea_assignment)
    end

    def test_valid_with_activity
      assert @assignment.valid?
    end

    def test_requires_activity
      @assignment.activity = nil

      refute @assignment.valid?
      assert_includes @assignment.errors[:activity], "must exist"
    end

    def test_defaults_published_to_false
      assignment = Tarea::Assignment.create!(
        title: "Week 1",
        activity: FactoryBot.create(:tarea_activity),
        grading_scheme: {}
      )

      assignment.reload

      assert_equal false, assignment.published
    end
  end
end
