class SectionsController < ApplicationController
  def update
    @assessment = current_org.assessment
    @assessment.update_section(params[:id], params[:section])
    redirect_to assessment_path(:tab => params[:id])
  end
end
