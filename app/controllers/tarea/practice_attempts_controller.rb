module Tarea
  class PracticeAttemptsController < ApplicationController
    def show
      @activity = Tarea::Activity.find(params[:activity_id])
      @attempt = find_or_create_attempt
      @prompt = @attempt.next_prompt

      if @prompt.nil?
        render :complete
      else
        render :show
      end
    end

    def create_response
      @activity = Tarea::Activity.find(params[:activity_id])
      @attempt = find_or_create_attempt
      @prompt = @activity.prompts.find(params[:prompt_id])

      @result = Tarea::Attempts::SubmitResponse.call(
        attempt: @attempt,
        prompt: @prompt,
        submitted_answer: params[:submitted_answer]
      )

      Tarea::Attempts::Finalize.call(attempt: @attempt)
      @attempt.reload
      @feedback_mode = true

      render :show
    end

    def advance
      @activity = Tarea::Activity.find(params[:activity_id])
      @attempt = find_or_create_attempt
      @prompt = @attempt.next_prompt

      if @prompt.nil?
        render :complete
      else
        render :show
      end
    end

    private

    def find_or_create_attempt
      Tarea::Attempt.where(
        user_key: current_user.id.to_s,
        activity: @activity,
        assignment: @assignment
      ).order(created_at: :desc).first_or_create!(
        status: :in_progress,
        started_at: Time.current
      )
    end
  end
end
