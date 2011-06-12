class AnswersController < ApplicationController

  def create
    redirect_to assessment_path(current_org.assessment)
  end

end