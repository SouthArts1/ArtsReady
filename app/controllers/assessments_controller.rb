class AssessmentsController < ApplicationController
  
  def new
    if current_org.assessment.present?
      redirect_to assessment_path(current_org.assessment)
    else
      @assessment = Assessment.new
    end
  end
  
  def create
    @assessment = current_org.create_assessment unless current_org.assessment.present?
    redirect_to assessment_path(@assessment)
  end
  
  def show
    redirect_to new_assessment_path unless current_org.assessment.present? 
    @assessment = current_org.assessment
  end
  
end
