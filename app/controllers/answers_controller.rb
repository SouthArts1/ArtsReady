class AnswersController < ApplicationController

  def reconsider
    @answer = current_org.assessment.answers.find(params[:id])
    if @answer.update_attribute(:was_skipped,false)
      flash.notice = 'You can now answer this question.'
    else
      flash.notice = 'Problem with considering the question'
    end
    redirect_to :back
  end
  
  def skip
    @answer = current_org.assessment.answers.find(params[:id])
    if @answer.update_attribute(:was_skipped,true)
      flash.notice = 'You skipped that question, but you can always reconsider.'
    else
      flash.notice = 'Problem with considering the question'
    end
    redirect_to :back
  end

  def update
    @answer = current_org.assessment.answers.find(params[:id])

    if @answer.update_attributes(params[:answer])
      flash.notice = 'Answer was successfully updated.'
    else
      flash.notice = 'All fields are required for your answer'
    end

    if request.xhr?
      render :partial => 'assessments/assessment_question',
        :locals => {:answer => @answer}
    else
      redirect_to :back
    end
  end
  

end
