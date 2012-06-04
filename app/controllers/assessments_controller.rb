class AssessmentsController < ApplicationController

  def new
    current = current_org.assessment
    if current && !current.complete?
      redirect_to assessment_path
    else
      @assessment = current_org.build_assessment
      @assessment.initialize_critical_functions
    end
  end

  def create
    @assessment = current_org.create_assessment(params[:assessment]) #unless current_org.assessment.present?
    redirect_to assessment_path
  end

  def show
    redirect_to new_assessment_path unless current_org.assessment.present?
    @assessment = current_org.assessment
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
