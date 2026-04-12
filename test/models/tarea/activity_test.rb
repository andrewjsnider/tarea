require "test_helper"

module Tarea
  class ActivityTest < ActiveSupport::TestCase
    def setup
      @activity = FactoryBot.build(:tarea_activity)
    end

    def test_valid_with_required_attributes
      assert @activity.valid?
    end

    def test_requires_kind
      @activity.kind = nil

      refute @activity.valid?
      assert_includes @activity.errors[:kind], "can't be blank"
    end

    def test_defaults_xp_value_to_zero
      activity = Tarea::Activity.create!(
        title: "Practice 1",
        kind: :practice,
        metadata: {}
      )

      assert_equal 0, activity.reload.xp_value
    end

    def test_supports_defined_kinds
      assert_equal "reading_comprehension", @activity.kind

      @activity.kind = :practice

      assert_equal "practice", @activity.kind
    end
  end
end
