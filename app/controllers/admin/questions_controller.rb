class Admin::QuestionsController < ApplicationController

  def index
    critical_function = (params[:tab] ||= 'people')
    @questions = Question.where(:critical_function => critical_function)
  end
  
  def new
    @question = Question.new(:critical_function => params[:critical_function])
  end
  
  def create
    @question = Question.create(params[:question])
    if @question.save
      redirect_to admin_questions_path, :notice => "Question added"
    else
      render :new, :notice => "Problem with your question"
    end
  end
  
  def edit
    @question = Question.includes(:action_items).find(params[:id])
  end
  
  def update
    @question = Question.find(params[:id])

    if @question.update_attributes(params[:question])
      redirect_to admin_questions_path, :notice => "Question updated"
    else
      render :edit, :notice => "Problem updating question"
    end

  end
  

end