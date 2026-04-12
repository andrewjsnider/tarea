require "test_helper"

module Tarea
  class PromptTest < ActiveSupport::TestCase
    def setup
      @prompt = FactoryBot.build(:tarea_prompt)
    end

    def test_valid_with_required_attributes
      assert @prompt.valid?
    end

    def test_requires_activity
      @prompt.activity = nil

      refute @prompt.valid?
      assert_includes @prompt.errors[:activity], "must exist"
    end

    def test_requires_kind
      @prompt.kind = nil

      refute @prompt.valid?
      assert_includes @prompt.errors[:kind], "can't be blank"
    end

    def test_requires_text
      @prompt.text = nil

      refute @prompt.valid?
      assert_includes @prompt.errors[:text], "can't be blank"
    end

    def test_requires_position
      @prompt.position = nil

      refute @prompt.valid?
      assert_includes @prompt.errors[:position], "can't be blank"
    end

    def test_supports_defined_kinds
      assert_equal "multiple_choice", @prompt.kind

      @prompt.kind = :true_false

      assert_equal "true_false", @prompt.kind
    end
  end
end
