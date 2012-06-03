class ArchivedAssessmentsController < ApplicationController
  def index
    @assessments = current_org.assessments.complete
  end

  def show
    @assessment = current_org.assessments.complete.find(params[:id])
  end
end
