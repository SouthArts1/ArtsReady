class AnswersController < ApplicationController

  def update
    @answer = Answer.find(params[:id])

    if @answer.update_attributes(params[:answer])
      flash.notice = 'Answer was successfully updated.'
      
      # TODO put this into some kind of after_update filter in the answer model
      @answer.question.action_items.each do |i|
        current_org.todos.create(:action_item => i)
        logger.debug("Adding todo #{i.description} for question #{@answer.question.description}")
      end
      
    end
    redirect_to assessment_path(current_org.assessment)
  end

end