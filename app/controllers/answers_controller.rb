class AnswersController < ApplicationController

  def update
    @answer = Answer.find(params[:id])

    if @answer.update_attributes(params[:answer])
      flash.notice = 'Post was successfully updated.'
    end
    redirect_to assessment_path(current_org.assessment)
  end

end