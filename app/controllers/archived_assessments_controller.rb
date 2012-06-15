class ArchivedAssessmentsController < ApplicationController
  def index
    @assessments = current_org.assessments.complete
  end

  def show
    @assessment = current_org.assessments.complete.find(params[:id])
    critical_function = (params[:tab] ||= 'people')    
    @answers = @assessment.answers.includes(:question)

    respond_to do |format|
      format.csv do
        render :layout => false
      end
      format.html do
        @answers = @answers.for_critical_function(critical_function)
      end
    end
  end
end
