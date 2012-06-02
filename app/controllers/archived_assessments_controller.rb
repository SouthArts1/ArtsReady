class ArchivedAssessmentsController < ApplicationController
  def index
    @assessments = current_org.assessments.complete
  end
end
