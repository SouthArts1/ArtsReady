class AnswersController < ApplicationController

  def reconsider
    @answer = current_org.assessment.answers.find(params[:id])
    if @answer.reconsider!
      flash.notice = 'You can now answer this question.'
    else
      flash.notice = 'Problem with considering the question'
    end

    respond
  end
  
  def skip
    @answer = current_org.assessment.answers.find(params[:id])
    if @answer.skip!
      flash.notice = 'You skipped that question, but you can always reconsider.'
    else
      flash.notice = 'Problem with considering the question'
    end

    respond
  end

  def update
    @answer = current_org.assessment.answers.find(params[:id])

    if @answer.update_attributes(answer_params)
      flash.notice = 'Answer was successfully updated.'
    else
      flash.notice = 'All fields are required for your answer'
    end

    respond
  end

private

  def answer_params
    params.require(:answer).permit(
      :preparedness, :priority
    )
  end

  def respond
    if request.xhr?
      @assessment = @answer.assessment
      @critical_function = @answer.critical_function
      @notice = flash.delete(:notice)
      render 'update'
    else
      redirect_to :back
    end
  end
end
