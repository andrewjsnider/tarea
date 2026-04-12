require "test_helper"

module Tarea
  class ResponseTest < ActiveSupport::TestCase
    def setup
      @response = FactoryBot.build(:tarea_response)
    end

    def test_valid_with_required_attributes
      assert @response.valid?
    end

    def test_requires_attempt
      @response.attempt = nil

      refute @response.valid?
      assert_includes @response.errors[:attempt], "must exist"
    end

    def test_requires_prompt
      @response.prompt = nil

      refute @response.valid?
      assert_includes @response.errors[:prompt], "must exist"
    end

    def test_defaults_points_earned_to_zero
      response = Tarea::Response.create!(
        attempt: FactoryBot.create(:tarea_attempt),
        prompt: FactoryBot.create(:tarea_prompt),
        response: { "answer" => "Está contento" }
      )

      assert_equal 0, response.points_earned
    end
  end
end
